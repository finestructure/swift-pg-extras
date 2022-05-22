// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "swift-pg-extras",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "pg-extras", targets: ["pg-extras"])
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
