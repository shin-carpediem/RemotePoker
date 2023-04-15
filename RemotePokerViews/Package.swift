// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "RemotePokerViews",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(
            name: "RemotePokerViews",
            targets: ["RemotePokerViews"])
    ],
    targets: [
        .target(
            name: "RemotePokerViews"),
        .testTarget(
            name: "RemotePokerViewsTests",
            dependencies: ["RemotePokerViews"]),
    ]
)
