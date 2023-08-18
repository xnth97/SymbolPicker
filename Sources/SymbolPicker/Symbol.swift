//
//  Symbol.swift
//  SymbolPicker
//
//  Created by Stefano Bertagno on 18/08/23.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A light abstraction over _SF Symbol_ identifiers.
public struct Symbol: Hashable, Identifiable, RawRepresentable {
    /// The unchecked symbol identifier.
    public let rawValue: String
    /// The unchecked symbol identifier.
    public var id: String { rawValue }
    /// The unchecked symbol identifier.
    public var name: String { rawValue }
    
    @_spi(Private)
    /// Initializes a symbol using their identifier.
    ///
    /// - Parameter rawValue: The symbol identifier.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Returns a symbol matching the provided identifier.
    ///
    /// - Parameter id: The symbol identifier.
    /// - Note: Use `init(name:)` when you're unsure about the symbol existence.
    public init<S: StringProtocol>(uncheckedName id: S) {
        self.init(rawValue: .init(id))
    }

    /// Initializes a symbol using using the provided identifier,
    /// as long as a valid _SF Symbol_ can be found.
    ///
    /// This will attempt to create an image and compare it against `nil`.
    ///
    /// - Parameter id: A possible symbol identifier.
    /// - Note: Use `init(uncheckedID:)` when you are passing valid identifiers.
    public init?<S: StringProtocol>(name id: S) {
        let id: String = .init(id)
        #if canImport(UIKit)
        guard UIImage(systemName: id) != nil else { return nil }
        self.init(rawValue: id)
        #elseif canImport(AppKit)
        guard NSImage(systemSymbolName: id, accessibilityDescription: nil) != nil else {
            return nil
        }
        self.init(rawValue: id)
        #else
        return nil
        #endif
    }
}

extension Symbol: CaseIterable {
    /// All symbols provided by the library.
    public static let allCases: [Symbol] = {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            return symbols(at: "sfsymbol4", in: .module)
        } else {
            return symbols(at: "sfsymbol", in: .module)
        }
    }()
    
    /// Fetch a list of newline-separated _SF Symbol_ identifiers
    /// from a `.txt` file.
    ///
    /// - Parameter fileName: The name of the `.txt` file inside the specified bundle.
    /// - Parameter bundle: The resource bundle.
    /// - Returns: A collection of unchecked `Symbol`s.
    public static func symbols(
        at fileName: String,
        in bundle: Bundle,
        file: StaticString = #file,
        line: Int = #line
    ) -> [Symbol] {
        guard let url = bundle.url(forResource: fileName, withExtension: "txt"),
              let content = try? String(contentsOf: url) else {
            #if DEBUG
            assertionFailure("[SymbolPicker:\(file):\(line)] Failed to load bundle resource file.")
            #endif
            return []
        }
        return content.split(separator: "\n").map(Symbol.init(uncheckedName:))
    }
}

extension Symbol: ExpressibleByStringLiteral {
    /// Initializes the symbol without checks.
    ///
    /// - Parameter id: The unchecked symbol identifier.
    public init(stringLiteral id: String) {
        self.init(uncheckedName: id)
    }
}
