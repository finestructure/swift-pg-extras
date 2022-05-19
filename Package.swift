// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "swift-pg-extras",
    dependencies: [
    ],
    targets: [
        .executableTarget(name: "pg-extras", dependencies: []),
        .testTarget(name: "pg-extrasTests", dependencies: ["pg-extras"]),
    ]
)
