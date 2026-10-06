// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SyzygyAI",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "SyzygyAI", targets: ["SyzygyAI"])
    ],
    dependencies: [
        .package(url: "https://github.com/Syzygy-Hub/syzygy-foundation-ios.git", from: "3.0.0")
    ],
    targets: [
        .target(
            name: "SyzygyAI",
            dependencies: [
                .product(name: "SyzygyFoundation", package: "syzygy-foundation-ios")
            ],
            path: "Sources/SyzygyAI"
        ),
        .testTarget(
            name: "SyzygyAITests",
            dependencies: [
                "SyzygyAI",
                .product(name: "SyzygyFoundation", package: "syzygy-foundation-ios")
            ],
            path: "Tests/SyzygyAITests"
        )
    ]
)
