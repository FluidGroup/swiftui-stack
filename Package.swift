// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swiftui-stack",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "SwiftUIStack",
      targets: ["SwiftUIStack"]
    ),
    .library(
      name: "SwiftUIStackRideau",
      targets: ["SwiftUIStackRideau"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/FluidGroup/swiftui-support", from: "0.4.1"),
    .package(url: "https://github.com/FluidGroup/swiftui-snap-dragging-modifier", from: "1.1.0"),
    .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.2"),
    .package(url: "https://github.com/FluidGroup/Rideau", from: "2.3.0"),
  ],
  targets: [
    .target(
      name: "SwiftUIStack",
      dependencies: [
        .product(name: "SwiftUISupport", package: "swiftui-support"),
        .product(name: "SwiftUISnapDraggingModifier", package: "swiftui-snap-dragging-modifier"),
      ]
    ),
    .target(name: "SwiftUIStackRideau", dependencies: [
      "SwiftUIStack",
      .product(name: "SwiftUISupport", package: "swiftui-support"),
      .product(name: "Rideau", package: "Rideau"),
    ]),
    .testTarget(
      name: "SwiftUIStackTests",
      dependencies: ["SwiftUIStack", "ViewInspector"]
    ),
  ]
)
