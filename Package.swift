// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "MentraBluetoothSDK",
  platforms: [
    .iOS("15.1")
  ],
  products: [
    .library(
      name: "MentraBluetoothSDK",
      targets: ["MentraBluetoothSDK"]
    )
  ],
  targets: [
    .target(
      name: "MentraBluetoothSDK",
      dependencies: [
        "MentraBluetoothSDKCoreObjC"
      ],
      path: "ios/Source",
      resources: [
        .process("PrivacyInfo.xcprivacy")
      ]
    ),
    .target(
      name: "MentraBluetoothSDKCoreObjC",
      path: "ios/Packages/CoreObjC",
      publicHeadersPath: "include",
      cSettings: [
        .headerSearchPath(".")
      ]
    )
  ]
)
