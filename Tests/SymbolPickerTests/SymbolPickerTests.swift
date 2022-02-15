import XCTest
import SwiftUI
@testable import SymbolPicker

final class SymbolPickerTests: XCTestCase {

    @State var symbol: String = ""

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertNotNil(SymbolPicker(symbol: $symbol))
    }
}
