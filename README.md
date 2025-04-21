# MUDKit

**MUDKit** is an iOS framework designed to simplify app development and debugging.

## Features

- **Logging**: Flexible logging system with support for levels (debug, info, error, fault) and Pulse integration.
- **Feature Toggles**: Manage app functionality with the ability to override settings via UserDefaults.
- **Environments**: Support for multiple environments (e.g., dev, prod) with active environment selection.
- **Deeplinks**: Handle deeplinks using a configurable handler.
- **File System**: View, delete, and open files in .tmp and .documents directories.
- **Pulse**: Log network requests using Alamofire and Pulse.
- **Frame Geometry**: Debug SwiftUI view frames by overlaying a dashed border, displaying size and safe area insets, configurable via UserDefaults with customizable border color.
- **Debug UI**: Intuitive interface via `MUDKitView` for accessing all framework features.

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later
- Dependencies: Pulse, Alamofire, KeychainSwift

## Usage

### Initializing MUDKit

Configure the framework using `MUDKitConfigurator`. Example setup with Pulse, feature toggles, deeplinks, and environments:

```swift
import MUDKit

let devEnvironment = Environment(id: UUID(), name: "dev", parameters: ["api": "https://dev.api.com"])
let prodEnvironment = Environment(id: UUID(), name: "prod", parameters: ["api": "https://prod.api.com"])

let configuration = await MUDKitConfigurator.setup(
    pulseConfiguration: PulseConfiguration(
        configuration: .default,
        sessionDelegate: SessionDelegate(),
        delegateQueue: OperationQueue()
    ),
    featureToggleConfiguration: FeatureToggleConfiguration(featureToggles: [
        FeatureToggle(name: "newFeature", convenientName: "New Feature", isEnabled: false)
    ]),
    deeplinkConfiguration: DeeplinkConfiguration { url in
        print("Received deeplink: \(url)")
    },
    environmentConfiguration: EnvironmentConfiguration(
        environments: [devEnvironment, prodEnvironment],
        defaultEnvironmentId: devEnvironment.id
    )
)
```

### Checking Feature Toggles

Verify if a specific feature is enabled:

```swift
if MUDKitService.isFeatureToggleOn(name: "newFeature") {
    print("New feature is enabled")
} else {
    print("New feature is disabled")
}
```

### Logging

Use `Log` to log messages with different levels:

```swift
let logger = Log(subsystem: "com.yourapp", category: "network")
logger.info(logEntry: .text("Request started"))
logger.error(logEntry: .detailed(text: "Request failed", parameters: ["code": 404]))
```

### Debugging Frame Geometry

Apply the `frameGeometry` modifier to a SwiftUI view to debug its frame. Customize the border color and enable it via toggle in MUDKitView:

```swift
import SwiftUI
import MUDKit

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Debug Me")
                .frame(width: 100, height: 50)
                .frameGeometry(.blue) // Adds a blue dashed border and size info
        }
    }
}
```

The `frameGeometry` modifier displays a dashed border and text with the view's size and safe area insets when enabled.

### Using the Debug UI

Add `MUDKitView` to your app to access debugging tools:

```swift
import SwiftUI
import MUDKit

struct ContentView: View {
    var body: some View {
        MUDKitView()
    }
}
```
