// swift-tools-version: 6.0

import PackageDescription
import CompilerPluginSupport
import Foundation

let backend: String?
switch ProcessInfo.processInfo.environment["SCD_BACKEND"] {
case "SQLite":
    backend = "SQLite"
case "CoreData":
    backend = "CoreData"
case .some(let x):
    print("Unrecognized backend \(x). Using default backend for platform.")
    fallthrough
case nil:
    #if os(macOS) // Includes compiling for iOS etc
        backend = "CoreData"
    #else
        backend = "SQLite"
    #endif
}

var dependencies: [Target.Dependency] = ["SwiftCrossDataMacros"]
if backend == "SQLite" {
    dependencies.append(.product(name: "SQLite", package: "SQLite.swift"))
}

let swiftSettings: [SwiftSetting] = backend == "CoreData" ? [.define("CORE_DATA")] : []

let package = Package(
    name: "SwiftCrossData",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .macCatalyst(.v13)],
    products: [
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
        .package(
            url: "https://github.com/stackotter/swift-macro-toolkit.git",
            .upToNextMinor(from: "0.6.1")
        ),
        .package(
            url: "https://github.com/stephencelis/SQLite.swift.git",
            .upToNextMinor(from: "0.15.4")
        ),
    ],
    targets: [
        .macro(
            name: "SwiftCrossDataMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "MacroToolkit", package: "swift-macro-toolkit"),
            ]
        ),
        .target(
            name: "SwiftCrossData",
            dependencies: dependencies,
            swiftSettings: swiftSettings
        ),
        .executableTarget(name: "SwiftCrossDataClient", dependencies: ["SwiftCrossData"]),
        .testTarget(
            name: "SwiftCrossDataTests",
            dependencies: [
                "SwiftCrossDataMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
