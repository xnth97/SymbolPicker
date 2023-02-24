//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Simple singleton class for providing symbols list per platform availability.
class Symbols {

    /// Singleton instance.
    static let shared = Symbols()

    /// Array of all available symbol name strings.
    let allSymbols: [String]

    private init() {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol4")
        } else {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol")
        }
    }

    private static func fetchSymbols(fileName: String) -> [String] {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            #if DEBUG
            assertionFailure("[SymbolPicker] Failed to load bundle resource file.")
            #endif
            return []
        }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }

}
