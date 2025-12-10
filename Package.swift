// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClashParty",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "ClashParty",
            targets: ["ClashParty"]
        )
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .executableTarget(
            name: "ClashParty",
            dependencies: [],
            path: "ClashParty/Sources",
            exclude: [],
            sources: [
                "ClashPartyApp.swift",
                "ContentView.swift",
                "Core/CoreManager.swift",
                "Config/ConfigManager.swift",
                "Config/ProfileManager.swift",
                "System/SystemProxy.swift",
                "Utils/Logger.swift"
            ],
            resources: [
                .copy("../Resources/Assets.xcassets")
            ],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"])
            ]
        )
    ]
)
