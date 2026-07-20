# Mentra Bluetooth SDK for iOS

Native Swift package for building iOS apps that connect directly to Mentra smart glasses over Bluetooth.

## Installation

Add this repository in Xcode with Swift Package Manager:

```text
https://github.com/Mentra-Community/mentra-bluetooth-sdk-ios.git
```

Then add the `MentraBluetoothSDK` product to your app target.

For `Package.swift` consumers:

```swift
.package(
  url: "https://github.com/Mentra-Community/mentra-bluetooth-sdk-ios.git",
  from: "0.1.21-beta.0"
)
```

```swift
.product(name: "MentraBluetoothSDK", package: "mentra-bluetooth-sdk-ios")
```

## Requirements

- iOS 15.1 or newer
- Xcode 15 or newer
- A physical iPhone for Bluetooth testing

## Usage

```swift
import MentraBluetoothSDK

@MainActor
final class GlassesController: NSObject, MentraBluetoothSDKDelegate {
  private let sdk = MentraBluetoothSDK()
  private var selectedDevice: Device?

  override init() {
    super.init()
    sdk.delegate = self
  }

  func scan() throws {
    try sdk.scan(model: .mentraLive, timeout: 10) { devices in
      self.selectedDevice = devices.first
    }
  }

  func connect() throws {
    guard let selectedDevice else { return }
    try sdk.connect(to: selectedDevice)
  }

  func mentraBluetoothSDK(_ sdk: MentraBluetoothSDK, didUpdateGlasses glasses: GlassesRuntimeState) {
    print("Glasses changed: \(glasses)")
  }
}
```

## Permissions

Add Bluetooth usage text to your app's `Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app connects to your smart glasses over Bluetooth.</string>
```

If your app uses microphone features, also add:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app uses the microphone when you enable audio features.</string>
```

To keep the BLE link alive while the app is backgrounded, enable Core Bluetooth background mode:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>bluetooth-central</string>
</array>
```

## Scope

This Swift package contains the core iOS Bluetooth SDK. It intentionally excludes optional MentraOS-internal code paths for local STT, offline TTS, Nex/SwiftProtobuf, Vuzix/Ultralite, and tar.bz2 extraction.
