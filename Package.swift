// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "PGExtras",
    platforms: [.macOS(.v11)],
    products: [
        .executable(name: "pg-extras", targets: ["pg-extras"]),
        .library(name: "PGExtras", targets: ["PGExtras"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.1.2"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.10.0"),
        .package(url: "https://github.com/cfilipov/texttable.git", branch: "master"),
    ],
    targets: [
        .executableTarget(name: "pg-extras", dependencies: ["PGExtras"]),
        .target(name: "PGExtras", dependencies: [
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
            .product(name: "PostgresNIO", package: "postgres-nio"),
            .product(name: "TextTable", package: "texttable"),
        ]),
        .testTarget(name: "pg-extrasTests", dependencies: ["pg-extras"]),
    ]
)
