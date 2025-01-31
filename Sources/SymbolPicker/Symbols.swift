//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Simple singleton class for providing symbols list per platform availability.
@MainActor
public class Symbols: Sendable {

    /// Singleton instance.
    public static let shared = Symbols()

    /// Filter closure that checks each symbol name string should be included.
    public var filter: ((String) -> Bool)? {
        didSet {
            if let filter {
                symbols = allSymbols.filter { filter($0.name) }
            } else {
                symbols = allSymbols
            }
        }
    }

    /// Array of the symbol name strings to be displayed.
    private(set) var symbols: [Symbol]

    /// Array of all available symbol name strings.
    private let allSymbols: [Symbol]

    private init() {
        let filename = if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            "sfsymbol6"
        } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            "sfsymbol5"
        } else {
            "sfsymbol4"
        }
        self.allSymbols = Self.fetchSymbolsWithCategories(fileName: filename)
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
    
    private static func fetchSymbolsWithCategories(fileName: String) -> [Symbol] {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            #if DEBUG
            assertionFailure("[SymbolPicker] Failed to load bundle resource file.")
            #endif
            return []
        }
        return content
            .split(separator: "\n")
            .map { Symbol(String($0)) }
    }
}

