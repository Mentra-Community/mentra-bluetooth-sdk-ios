# Mentra Bluetooth SDK for iOS and macOS

Native Swift package for building iOS, iPadOS, and macOS apps that connect directly to Mentra smart glasses over Bluetooth. Native macOS apps can use AppKit or SwiftUI on Apple silicon and Intel Macs.

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
  from: "3.2.0-dev.136"
)
```

```swift
.product(name: "MentraBluetoothSDK", package: "mentra-bluetooth-sdk-ios")
```

## Requirements

- iOS 15.1 or newer
- macOS 13 or newer for native Mac apps
- Xcode 15 or newer
- A physical iPhone, iPad, or Mac for Bluetooth testing

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

For local photo receivers, LAN webhooks, or local OTA servers, also add:

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>This app accesses photo and OTA servers on your local network.</string>
```

On iOS, to keep the BLE link alive while the app is backgrounded, enable Core Bluetooth background mode:

```xml
<key>UIBackgroundModes</key>
<array>
  <string>bluetooth-central</string>
</array>
```

## Scope

Sandboxed macOS apps need the `com.apple.security.device.bluetooth` entitlement. Enable `com.apple.security.network.client` for uploads/OTA and `com.apple.security.device.audio-input` when capturing the Mac microphone. macOS does not use `UIBackgroundModes` or `AVAudioSession`; audio follows the Mac's selected output. ANCS notification relay is iOS-only.

This Swift package contains the core Apple-platform Bluetooth SDK. It intentionally excludes optional MentraOS-internal code paths for local STT, offline TTS, Nex/SwiftProtobuf, Vuzix/Ultralite, and tar.bz2 extraction.
