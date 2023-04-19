// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "RemotePokerData",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(name: "RemotePokerData", targets: ["RemotePokerData"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.8.0")
    ],
    targets: [
        .target(
            name: "RemotePokerData",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ]),
        .testTarget(
            name: "RemotePokerDataTests",
            dependencies: ["RemotePokerData"]),
    ]
)
