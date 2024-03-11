// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SPCServer",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.92.0"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", from: "2.5.3")
    ],
    targets: [
        .executableTarget(
            name: "SPCServer",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "SwiftSoup", package: "SwiftSoup")
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
