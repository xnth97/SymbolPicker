//
//  SymbolPickerTests.swift
//  SymbolPickerTests
//
//  Created by Yubo Qin on 2/23/23.
//

import Testing
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
@testable import SymbolPicker

@MainActor
struct SymbolPickerTests {

    init() {
        Symbols.shared.filter = nil
    }

    @Test("Test initialization of symbols")
    func testSymbols() {
        let allSymbols = Symbols.shared.symbols
        allSymbols.forEach { symbol in
            assertImage(systemName: symbol.name)
        }
    }

    @Test("Test filtering of symbols")
    func testFilter() {
        Symbols.shared.filter = { $0.contains(".circle") }
        let symbols = Symbols.shared.symbols
        symbols.forEach {
            #expect($0.name.contains(".circle"))
        }
    }
    
    @Test("Test categories of symbols")
    func testCategories() {
        SymbolCategory.allCases.forEach { category in
            Symbols.shared.filter = { $0.contains(category.name) }
            let symbols = Symbols.shared.symbols
            symbols.forEach {
                #expect($0.categories.contains(category))
            }
        }
    }

    private func assertImage(systemName: String) {
        #if canImport(UIKit)
        #expect(UIImage(systemName: systemName) != nil)
        #elseif canImport(AppKit)
        #expect(NSImage(systemSymbolName: systemName, accessibilityDescription: nil) != nil)
        #endif
    }

}
