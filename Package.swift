// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Grids",
    products: [
        .library(
            name: "Grids",
            targets: ["Grids"]),
    ],
    dependencies: [
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
