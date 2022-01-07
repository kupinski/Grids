// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Grids",
//    platforms: [.macOS(.v10_10), .iOS(.v8)],
    products: [
        .library(
            name: "Grids",
            targets: ["Grids"]),
    ],
    targets: [
        .target(
            name: "Grids",
            dependencies: []),
        .testTarget(
            name: "GridsTests",
            dependencies: ["Grids"]),
    ]
)
