// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftStuff",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftStuff",
            targets: ["SwiftStuff"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftStuff",
            dependencies: []),
        .testTarget(
            name: "SwiftStuffTests",
            dependencies: ["SwiftStuff"]),
    ]
)
