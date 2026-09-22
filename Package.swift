// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SyzygyAI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(name: "SyzygyAI", targets: ["SyzygyAI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Syzygy-Hub/syzygy-foundation-ios.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "SyzygyAI",
            dependencies: [
                .product(name: "SyzygyFoundation", package: "syzygy-foundation-ios"),
            ],
            path: "Sources/SyzygyAI"
        ),
        .testTarget(
            name: "SyzygyAITests",
            dependencies: ["SyzygyAI"],
            path: "Tests/SyzygyAITests"
        ),
    ]
)
