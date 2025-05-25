// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CardsDataKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ModuleNetworking", targets: ["ModuleNetworking"]),
        .library(name: "ModuleAnalytics", targets: ["ModuleAnalytics"]),
        .library(name: "ModuleConfig", targets: ["ModuleConfig"]),
        .library(name: "ModuleCore", targets: ["ModuleCore"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ModuleNetworking",
            dependencies: [],
            path: "Sources/ModuleNetworking"
        ),
        .target(
            name: "ModuleAnalytics",
            dependencies: [],
            path: "Sources/ModuleAnalytics"
        ),
        .target(
            name: "ModuleConfig",
            dependencies: [],
            path: "Sources/ModuleConfig",
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "ModuleCore",
            dependencies: ["ModuleNetworking", "ModuleAnalytics", "ModuleConfig"],
            path: "Sources/ModuleCore"
        ),
        .testTarget(
            name: "ModuleNetworkingTests",
            dependencies: ["ModuleNetworking"],
            path: "Tests/ModuleNetworkingTests"
        ),
        .testTarget(
            name: "ModuleAnalyticsTests",
            dependencies: ["ModuleAnalytics"],
            path: "Tests/ModuleAnalyticsTests"
        ),
        .testTarget(
            name: "ModuleConfigTests",
            dependencies: ["ModuleConfig"],
            path: "Tests/ModuleConfigTests",
            resources: [.copy("cards.json")]
        ),
        .testTarget(
            name: "ModuleCoreTests",
            dependencies: ["ModuleCore"],
            path: "Tests/ModuleCoreTests"
        )
    ]
)
