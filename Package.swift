// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PurchasePackage",
  platforms: [.iOS("16.0")],
  products: [
    .library(
      name: "PurchasePackage",
      targets: ["PurchasePackage"]
    )
  ],

  // MARK: External Dependencies

  dependencies: [
    .package(
      url: "https://github.com/RevenueCat/purchases-ios.git",
      from: "4.0.0"
    ),
    .package(
      url: "https://github.com/BlackMirrorz/NetworkingLayer.git",
      from: "1.0.0"
    )
  ],

  // MARK: Imports For This Package

  targets: [
    .target(
      name: "PurchasePackage",
      dependencies: [
        .product(name: "NetworkingLayer", package: "NetworkingLayer"),
        .product(name: "RevenueCat", package: "purchases-ios")
      ]
    ),
    .testTarget(
      name: "PurchasePackageTests",
      dependencies: ["PurchasePackage"]
    )
  ],
  swiftLanguageVersions: [.v5]
)
