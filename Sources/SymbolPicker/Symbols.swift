//
//  Symbols.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 1/12/23.
//

import Foundation

/// Simple singleton class for providing symbols list per platform availability.
class Symbols {

    static let shared = Symbols()

    private(set) var allSymbols: [String]

    private init() {
        self.allSymbols = []

        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            allSymbols = fetchSymbols(fileName: "sfsymbol4")
        } else {
            allSymbols = fetchSymbols(fileName: "sfsymbol")
        }
    }

    private func fetchSymbols(fileName: String) -> [String] {
        guard let path = Bundle.module.path(forResource: fileName, ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
            return []
        }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }

}
