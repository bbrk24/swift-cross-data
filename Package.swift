// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "SwiftCrossData",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftCrossData",
            targets: ["SwiftCrossData"]
        ),
        .executable(
            name: "SwiftCrossDataClient",
            targets: ["SwiftCrossDataClient"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "600.0.0-latest"),
        .package(url: "https://github.com/stackotter/swift-macro-toolkit.git", .upToNextMinor(from: "0.6.1")),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", .upToNextMinor(from: "0.15.4")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "SwiftCrossDataMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit")
            ]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "SwiftCrossData",
            dependencies: [
                "SwiftCrossDataMacros",
                .product(name: "SQLite", package: "SQLite.swift", condition: .when(platforms: [.linux, .windows])),
            ]
        ),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "SwiftCrossDataClient", dependencies: ["SwiftCrossData"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "SwiftCrossDataTests",
            dependencies: [
                "SwiftCrossDataMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
