// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "swift-pg-extras",
    platforms: [.macOS(.v12)],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2")
    ],
    targets: [
        .executableTarget(name: "pg-extras", dependencies: ["PGExtras"]),
        .target(name: "PGExtras", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ]),
        .testTarget(name: "pg-extrasTests", dependencies: ["pg-extras"]),
    ]
)
