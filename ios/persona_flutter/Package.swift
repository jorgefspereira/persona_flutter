// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "persona_flutter",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "persona-flutter", targets: ["persona_flutter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Keep in sync with the PersonaInquirySDK2 version in ios/persona_flutter.podspec.
        .package(url: "https://github.com/persona-id/inquiry-ios-2.git", exact: "2.41.1")
    ],
    targets: [
        .target(
            name: "persona_flutter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "PersonaInquirySDK2", package: "inquiry-ios-2")
            ]
        )
    ]
)
