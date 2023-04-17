// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "RemotePokerDomains",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(
            name: "RemotePokerDomains",
            targets: ["RemotePokerDomains"])
    ],
    dependencies: [
        .package(path: "../RemotePokerData")
    ],
    targets: [
        .target(
            name: "RemotePokerDomains",
            dependencies: [
                "RemotePokerData"
            ]),
        .testTarget(
            name: "RemotePokerDomainsTests",
            dependencies: ["RemotePokerDomains"]),
    ]
)
