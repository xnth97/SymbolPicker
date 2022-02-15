# SymbolPicker

A simple and searchable SFSymbol Picker for SwiftUI

![](https://img.shields.io/badge/License-MIT-green)
![](https://img.shields.io/badge/Platform-iOS-blue)

## Features

SymbolPicker provides a simple interface for picking a SFSymbol with search functionality that is backported to iOS 14. SymbolPicker is implemented with SwiftUI and is suggested to use within `sheet` (please see example below).

## Usage

### Requirements

* iOS 14.0+
* Xcode 13.0+
* Swift 5.0+

### Installation

SymbolPicker is available as a Swift Package. Add this repo to your project through Xcode GUI or `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/xnth97/SymbolPicker.git", .upToNextMajor(from: "1.0.0"))
]
```

### Example

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

![](/Screenshots/demo.png)

## TODO

- [ ] Categories support
- [ ] Multiplatform
- [ ] Inline UI
- [ ] Codegen from latest SF Symbols

## License

SymbolPicker is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
