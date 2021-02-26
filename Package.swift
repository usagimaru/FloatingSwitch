// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FloatingSwitch",
	platforms: [
		.iOS(.v13),
	],
    products: [
        .library(
            name: "FloatingSwitch",
            targets: ["FloatingSwitch"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "FloatingSwitch",
			path: "Sources"),
    ],
	swiftLanguageVersions: [SwiftVersion.v5]
)
