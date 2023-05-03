// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swiftui-stack",
  platforms: [.iOS(.v14)],
  products: [
    .library(
      name: "Stack",
      targets: ["Stack"]
    ),
    .library(
      name: "FluidStack",
      targets: ["FluidStack"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/FluidGroup/FluidInterfaceKit.git", from: "0.5.0"),
    .package(url: "https://github.com/FluidGroup/swiftui-GestureVelocity", from: "0.1.0"),
//    .package(url: "https://github.com/FluidGroup/swiftui-support", from: "0.3.0"),
    .package(url: "https://github.com/FluidGroup/swiftui-support", branch: "main"),
    .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.9.2"),
  ],
  targets: [
    .target(
      name: "Stack",
      dependencies: [
        .product(name: "GestureVelocity", package: "swiftui-GestureVelocity"),
        .product(name: "SwiftUISupport", package: "swiftui-support"),
      ]
    ),
    .target(
      name: "FluidStack",
      dependencies: [
        "Stack",
        .product(name: "FluidInterfaceKit", package: "FluidInterfaceKit"),
      ]
    ),
    .testTarget(
      name: "StackTests",
      dependencies: ["Stack", "ViewInspector"]
    ),
  ]
)
