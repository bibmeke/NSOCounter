
import Foundation
import Vapor
import RedisProvider

// MARK: - Enum

enum RedisKey {
    static let totalCount = "total_count"
    static let access = "access:"
}

// MARK: - Config

let config = try Config()
try config.addProvider(RedisProvider.Provider.self)
let drop = try Droplet(config)

// MARK: - Droplet

drop.get("counter.js") { request in
    let count = try drop.cache.get(RedisKey.totalCount)?.int ?? 0
    var newCount: Int?

    if let realIp = request.headers["X-Real-IP"] {
        let key = RedisKey.access + realIp

        if try drop.cache.get(key) == nil {
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
            formatter.locale = Locale(identifier: "ja_JP")

            let nextDay = formatter.date(from: formatter.string(from: Date(timeIntervalSinceNow: 24 * 60 * 60)))!
            try drop.cache.set(key, 1, expiration: nextDay)

            // Total Count
            newCount = count + 1
            try drop.cache.set(RedisKey.totalCount, newCount)
        }
    }

    return """
    function setCounter() {
        document.getElementById("counter").innerHTML = "あなたは\(newCount ?? count)番目のお客様です";
    }
    """
}

try drop.run()
