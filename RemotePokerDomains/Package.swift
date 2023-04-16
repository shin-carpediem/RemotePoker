// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "RemotePokerDomains",
    products: [
        .library(
            name: "RemotePokerDomains",
            targets: ["RemotePokerDomains"])
    ],
    targets: [
        .target(
            name: "RemotePokerDomains"),
        .testTarget(
            name: "RemotePokerDomainsTests",
            dependencies: ["RemotePokerDomains"]),
    ]
)
