# SymbolPicker

A simple and cross-platform SFSymbol picker for SwiftUI

![](https://img.shields.io/badge/License-MIT-green)
![](https://img.shields.io/badge/Platform-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-blue)

## Features

SymbolPicker provides a simple and cross-platform interface for picking a SFSymbol with search functionality that is backported to iOS 14. SymbolPicker is implemented with SwiftUI and supports iOS, macOS, tvOS and watchOS platforms.

![](/Screenshots/demo.png)

## Usage

### Requirements

* iOS 14.0+ / macOS 12.0+ / tvOS 15.0+ / watchOS 8.0+
* Xcode 13.0+
* Swift 5.0+

### Installation

SymbolPicker is available as a Swift Package. Add this repo to your project through Xcode GUI or `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/xnth97/SymbolPicker.git", .upToNextMajor(from: "1.1.0"))
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
        Button(action: {
            iconPickerPresented = true
        }) {
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
- [ ] Inline UI
- [ ] Codegen from latest SF Symbols

## License

SymbolPicker is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
