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
    dependencies: [
        .package(path: "../RemotePokerDomains"),
        .package(url: "https://github.com/costachung/neumorphic", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "RemotePokerViews",
            dependencies: [
                "RemotePokerDomains",
                .product(name: "Neumorphic", package: "neumorphic"),
            ]),
        .testTarget(
            name: "RemotePokerViewsTests",
            dependencies: ["RemotePokerViews"]),
    ]
)
