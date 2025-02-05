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
        let categories: [SymbolCategory] = [.maps]
        let symbols = Symbols.shared.symbols.filter { !$0.categories.isDisjoint(with: categories) }
        
        assert(symbols.contains { $0.name.contains("figure.walk") })
        assert(!symbols.contains { $0.name.contains("pencil") })
    }
    
    @Test("Test ability to add custom categories of symbols")
    func testCustomCategories() {
        let categories: [SymbolCategory] = [SymbolCategory("circles", systemImage: "circle", isMember: { $0.name.contains("circle") })]
        let symbols = Symbols.shared.symbols.filter { symbol in categories.contains(where: { $0.isMember(symbol) } )}
        assert(symbols.contains { $0.name == "pencil.circle" })
        assert(!symbols.contains { $0.name == "pencil" })
    }

    private func assertImage(systemName: String) {
        #if canImport(UIKit)
        #expect(UIImage(systemName: systemName) != nil)
        #elseif canImport(AppKit)
        #expect(NSImage(systemSymbolName: systemName, accessibilityDescription: nil) != nil)
        #endif
    }
}
