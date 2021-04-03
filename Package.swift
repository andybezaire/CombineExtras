// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CombineExtras",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "CombineExtras", targets: ["CombineExtras"])
    ],
    dependencies: [],
    targets: [
        .target(name: "CombineExtras", dependencies: []),
        .testTarget(name: "CombineExtrasTests", dependencies: ["CombineExtras"])
    ]
)
