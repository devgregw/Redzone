// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SPCServer",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.114.1")
    ],
    targets: [
        .executableTarget(
            name: "SPCServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://www.swift.org/server/guides/building.html#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "SPCServerTests", dependencies: [
            .target(name: "SPCServer"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
