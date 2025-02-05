//
//  Symbol.swift
//  SymbolPicker
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import Foundation

/// `Symbol` is a class that represents an SF Symbol with its categories.
public class Symbol: Identifiable {
    /// The system name of the symbol.
    let name: String
    /// The categories of the symbol.
    let categories: Set<SymbolCategory>
    
    public var id: String { name }
    
    init(_ line: String) {
        let components = line.split(separator: ",")
        guard components.count > 0 else { fatalError("Invalid symbol line: \(line)") }
        
        self.name = String(components[0])
        self.categories = Set(components.dropFirst().map(Self.parseCategory))
    }
    
    private static func parseCategory(_ input: String.SubSequence) -> SymbolCategory {
        guard let category = SymbolCategory.defaultCategory(from: String(input)) else {
            fatalError("Could not find default category for \(input)")
        }
        return category
    }
}
