// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SymbolPicker",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16),
        .macCatalyst(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SymbolPicker",
            targets: ["SymbolPicker"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SymbolPicker",
            dependencies: [
            ],
            path: "Sources/SymbolPicker",
            resources: [
                .process("Resources"),
            ]),
        .testTarget(
            name: "SymbolPickerTests",
            dependencies: ["SymbolPicker"]),
    ]
)
