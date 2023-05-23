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
  ],
  dependencies: [
    .package(url: "https://github.com/FluidGroup/swiftui-support", from: "0.4.1"),
    .package(url: "https://github.com/FluidGroup/swiftui-snap-dragging-modifier", from: "1.1.2"),
    .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.2"),
  ],
  targets: [
    .target(
      name: "SwiftUIStack",
      dependencies: [
        .product(name: "SwiftUISupport", package: "swiftui-support"),
        .product(name: "SwiftUISnapDraggingModifier", package: "swiftui-snap-dragging-modifier"),
      ]
    ),
    .testTarget(
      name: "SwiftUIStackTests",
      dependencies: ["SwiftUIStack", "ViewInspector"]
    ),
  ]
)
