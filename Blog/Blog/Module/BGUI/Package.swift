// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BGUI",
    platforms: [.iOS("13.0"), .macOS("11.00")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BGUI",
            targets: ["BGUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        //.package(url: /* package url */, from: "1.0.0"),
	//package(path:"../")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BGUI",
            dependencies: []),
        .testTarget(
            name: "BGUITests",
            dependencies: ["BGUI"]),
    ]
)