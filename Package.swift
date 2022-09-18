// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let package = Package(
    name: "SpicyWrap",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "SpicyWrap", targets: ["SpicyWrap"]),
    ],
    dependencies: [
        .package(url: "https://github.com/whutao/everything-at-once.git", branch: "master")
    ],
    targets: [
        .target(
            name: "SpicyWrap",
            dependencies: []
        ),
        .testTarget(
            name: "SpicyWrapTests",
            dependencies: ["SpicyWrap"]
        ),
    ]
)
