// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "CardsDataKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "ModuleNetworking", targets: ["ModuleNetworking"]),
        .library(name: "ModuleAnalytics", targets: ["ModuleAnalytics"])
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
        .testTarget(
            name: "ModuleNetworkingTests",
            dependencies: ["ModuleNetworking"],
            path: "Tests/ModuleNetworkingTests"
        ),
        .testTarget(
            name: "ModuleAnalyticsTests",
            dependencies: ["ModuleAnalytics"],
            path: "Tests/ModuleAnalyticsTests"
        )
    ]
)