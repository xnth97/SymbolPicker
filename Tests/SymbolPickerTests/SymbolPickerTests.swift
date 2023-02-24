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
        let allSymbols = Symbols.shared.allSymbols
        allSymbols.forEach { symbol in
            assertImage(systemName: symbol)
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
