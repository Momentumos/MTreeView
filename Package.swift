// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTreeView",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MTreeView",
            targets: ["MTreeView"]),
    ],
    targets: [
        .target(
            name: "MTreeView"
        ),

    ]
)
