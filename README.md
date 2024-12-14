# SymbolPicker

A simple and cross-platform SFSymbol picker for SwiftUI

![](https://img.shields.io/badge/license-MIT-green)
![](https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20visionOS-blue)
![](https://img.shields.io/github/v/release/xnth97/SymbolPicker?color=red)

## Features

SymbolPicker provides a simple and cross-platform interface for picking a SFSymbol. SymbolPicker is implemented with SwiftUI and supports iOS, macOS, watchOS, tvOS and visionOS platforms.

![](/Screenshots/demo.png)

![](/Screenshots/xros.png)

## Usage

### Requirements

* iOS 16.0+ / macOS 13.0+ / watchOS 9.0+ / tvOS 16.0+ / visionOS 1.0+
* Xcode 16.0+
* Swift 6.0+

### Installation

SymbolPicker is available as a Swift Package. Add this repo to your project through Xcode GUI or `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/xnth97/SymbolPicker.git", .upToNextMajor(from: "1.6.0"))
]
```

### Example

It is suggested to use SymbolPicker within a `sheet`.

```swift
import SwiftUI
import SymbolPicker

struct ContentView: View {
    @State private var iconPickerPresented = false
    @State private var icon = "pencil"

    var body: some View {
        Button {
            iconPickerPresented = true
        } label: {
            HStack {
                Image(systemName: icon)
                Text(icon)
            }
        }
        .sheet(isPresented: $iconPickerPresented) {
            SymbolPicker(symbol: $icon)
        }
    }
}
```

## TODO

- [ ] Categories support
- [x] Multiplatform support
- [x] Platform availability support
- [ ] Codegen from latest SF Symbols
- [x] Nullable symbol

## License

SymbolPicker is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
