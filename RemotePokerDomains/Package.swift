// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "RemotePokerDomains",
    defaultLocalization: "en",
    platforms: [.iOS(.v15), .macOS(.v10_15)],
    products: [
        .library(name: "RemotePokerDomains", targets: ["RemotePokerDomains"]),
        .library(name: "RemotePokerModel", targets: ["Model"]),
        .library(name: "RemotePokerViewModel", targets: ["ViewModel"]),
        .library(name: "RemotePokerProtocols", targets: ["Protocols"]),
        .library(name: "RemotePokerTranslator", targets: ["Translator"]),
        .library(name: "EnterRoomDomain", targets: ["EnterRoomDomain"]),
        .library(name: "CardListDomain", targets: ["CardListDomain"]),
        .library(name: "Shared", targets: ["Shared"]),
        .library(name: "SettingDomain", targets: ["SettingDomain"]),
        .library(name: "SelectThemeColorDomain", targets: ["SelectThemeColorDomain"]),
    ],
    dependencies: [
        .package(path: "../RemotePokerData")
    ],
    targets: [
        .target(
            name: "RemotePokerDomains",
            dependencies: [
                "EnterRoomDomain",
                "CardListDomain",
                "SettingDomain",
                "SelectThemeColorDomain",
            ]),
        .target(
            name: "Model"
        ),
        .target(
            name: "ViewModel"
        ),
        .target(
            name: "Protocols",
            dependencies: [
                "Model",
                "ViewModel",
            ]
        ),
        .target(
            name: "Translator",
            dependencies: [
                "Model",
                "ViewModel",
                "Protocols",
            ]
        ),
        .target(
            name: "EnterRoomDomain",
            dependencies: [
                "RemotePokerData",
                "Model",
                "ViewModel",
                "Protocols",
                "Shared",
                "Translator",
            ]),
        .target(
            name: "CardListDomain",
            dependencies: [
                "RemotePokerData",
                "Model",
                "ViewModel",
                "Protocols",
                "Translator",
            ]),
        .target(
            name: "Shared",
            dependencies: [
               "Model",
            ]),
        .target(
            name: "SettingDomain",
            dependencies: [
                "RemotePokerData",
                "Model",
                "ViewModel",
                "Protocols",
                "Translator",
            ]),
        .target(
            name: "SelectThemeColorDomain",
            dependencies: [
                "RemotePokerData",
                "Model",
                "ViewModel",
                "Protocols",
                "Translator",
            ]),
        .testTarget(
            name: "RemotePokerDomainsTests",
            dependencies: ["RemotePokerDomains"]),
    ]
)
