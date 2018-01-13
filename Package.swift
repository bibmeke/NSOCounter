// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSOCounter",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.4.2")),
        .package(url: "https://github.com/vapor/redis-provider.git", .upToNextMajor(from: "2.0.1"))
    ],
    targets: [
        .target(
            name: "NSOCounter",
            dependencies: ["Vapor", "RedisProvider"]),
    ]
)
