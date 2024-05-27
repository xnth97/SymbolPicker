//
//  SymbolPickerTests.swift
//  SymbolPickerTests
//
//  Created by Yubo Qin on 2/23/23.
//

import XCTest
@testable import SymbolPicker

final class SymbolPickerTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        Symbols.shared.filter = nil
    }

    func testSymbols() {
        let allSymbols = Symbols.shared.symbols
        allSymbols.forEach { symbol in
            assertImage(systemName: symbol)
        }
    }

    func testFilter() {
        Symbols.shared.filter = { $0.contains(".circle") }
        let symbols = Symbols.shared.symbols
        symbols.forEach {
            XCTAssert($0.contains(".circle"))
        }
    }

    private func assertImage(systemName: String) {
        #if os(iOS) || os(watchOS) || os(tvOS)
        XCTAssertNotNil(UIImage(systemName: systemName))
        #else
        XCTAssertNotNil(NSImage(systemSymbolName: systemName, accessibilityDescription: nil))
        #endif
    }

}
