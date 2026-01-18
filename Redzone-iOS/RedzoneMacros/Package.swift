// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "RedzoneMacros",
    platforms: [.macOS(.v12), .iOS(.v14), .watchOS(.v7)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RedzoneMacros",
            targets: ["RedzoneMacros"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", .upToNextMajor(from: "602.0.0")),
        .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", .upToNextMinor(from: "0.63.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "RedzoneMacrosInternal",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "RedzoneMacros",
            dependencies: ["RedzoneMacrosInternal"],
            plugins: [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
            ]
        )
    ]
)
