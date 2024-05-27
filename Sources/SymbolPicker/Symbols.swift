//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Simple singleton class for providing symbols list per platform availability.
public class Symbols {

    /// Singleton instance.
    public static let shared = Symbols()

    /// Filter closure that checks each symbol name string should be included.
    public var filter: ((String) -> Bool)? {
        didSet {
            if let filter {
                symbols = allSymbols.filter(filter)
            } else {
                symbols = allSymbols
            }
        }
    }

    /// Array of the symbol name strings to be displayed.
    private(set) var symbols: [String]

    /// Array of all available symbol name strings.
    private let allSymbols: [String]

    private init() {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol5")
        } else if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol4")
        } else {
            self.allSymbols = Self.fetchSymbols(fileName: "sfsymbol")
        }
        self.symbols = self.allSymbols
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
