// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTreeView",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(
            name: "MTreeView",
            targets: [
                "MTreeView"
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "MTreeView",
            dependencies: [
                .product(name: "SwiftUIIntrospect", package: "swiftui-introspect")
            ]
        )
    ]
)
