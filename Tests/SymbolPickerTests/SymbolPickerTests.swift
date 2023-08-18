//
//  SymbolPickerTests.swift
//  SymbolPickerTests
//
//  Created by Yubo Qin on 2/23/23.
//

import XCTest
@testable import SymbolPicker

final class SymbolPickerTests: XCTestCase {

    func testSymbols() {
        Symbol.allCases.forEach(assertImage)
    }
    
    func testValidCheckedSymbols() {
        Symbol.allCases.forEach {
            XCTAssertNotNil(Symbol(name: $0.name))
        }
    }
    
    func testInvalidCheckedSymbol() {
        let symbol: Symbol? = .init(name: "<:invalid:>")
        XCTAssertNil(symbol)
    }

    private func assertImage(for symbol: Symbol) {
        #if os(iOS) || os(watchOS) || os(tvOS)
        XCTAssertNotNil(UIImage(systemName: symbol.name))
        #else
        XCTAssertNotNil(NSImage(systemSymbolName: symbol.name, accessibilityDescription: nil))
        #endif
    }

}
