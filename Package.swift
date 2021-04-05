// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "CombineExtras",
    platforms: [.iOS(.v14), .macOS(.v11)],
    products: [
        .library(name: "CombineExtras", targets: ["CombineExtras"])
    ],
    dependencies: [
        .package(name: "Mocker", url: "https://github.com/andybezaire/Mocker.git", from: "2.3.0")
    ],
    targets: [
        .target(name: "CombineExtras", dependencies: []),
        .testTarget(name: "CombineExtrasTests", dependencies: ["CombineExtras", "Mocker"])
    ]
)
