//
//  SymbolCategory.swift
//  SymbolPicker
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import Foundation

extension [SymbolCategory] {
    public static let all = [SymbolCategory.all]
}

/// `SymbolCategory` is a struct that represents categories of SF Symbols.
public struct SymbolCategory: CaseIterable, Equatable, Hashable, Sendable {
    public static let allCases: [SymbolCategory] = Array(defaultCategories.values)
    public static let all = SymbolCategory("All", systemImage: "circle", isMember: { _ in true })
    public static let whatsnew = defaultCategory("whatsnew")
    public static let multicolor = defaultCategory("multicolor")
    public static let variablecolor = defaultCategory("variablecolor")
    public static let communication = defaultCategory("communication")
    public static let weather = defaultCategory("weather")
    public static let maps = defaultCategory("maps")
    public static let objectsandtools = defaultCategory("objectsandtools")
    public static let devices = defaultCategory("devices")
    public static let cameraandphotos = defaultCategory("cameraandphotos")
    public static let gaming = defaultCategory("gaming")
    public static let connectivity = defaultCategory("connectivity")
    public static let transportation = defaultCategory("transportation")
    public static let accessibility = defaultCategory("cccessibility")
    public static let privacyandsecurity = defaultCategory("privacyandsecurity")
    public static let human = defaultCategory("human")
    public static let home = defaultCategory("home")
    public static let fitness = defaultCategory("fitness")
    public static let nature = defaultCategory("nature")
    public static let editing = defaultCategory("editing")
    public static let textformatting = defaultCategory("textformatting")
    public static let media = defaultCategory("media")
    public static let keyboard = defaultCategory("keyboard")
    public static let commerce = defaultCategory("commerce")
    public static let time = defaultCategory("time")
    public static let health = defaultCategory("health")
    public static let shapes = defaultCategory("shapes")
    public static let arrows = defaultCategory("arrows")
    public static let indices = defaultCategory("indices")
    public static let math = defaultCategory("math")
    
    public static func defaultCategory(from name: String) -> SymbolCategory? {
        defaultCategories[name]
    }
    
    public static func == (lhs: SymbolCategory, rhs: SymbolCategory) -> Bool {
        lhs.name == rhs.name
    }
    
    private static func defaultCategory(_ name: String) -> SymbolCategory {
        defaultCategory(from: name)!
    }
    
    private static let defaultCategories = Dictionary(uniqueKeysWithValues: [
        SymbolCategory("What's New", systemImage: "sparkles"),
        SymbolCategory("Multicolor", systemImage: "paintpalette"),
        SymbolCategory("Variable Color", systemImage: "slider.horizontal.below.square.and.square.filled"),
        SymbolCategory("Communication", systemImage: "message"),
        SymbolCategory("Weather", systemImage: "cloud.sun"),
        SymbolCategory("Maps", systemImage: "map"),
        SymbolCategory("Objects and Tools", systemImage: "folder"),
        SymbolCategory("Devices", systemImage: "desktopcomputer"),
        SymbolCategory("Camera and Photos", systemImage: "camera"),
        SymbolCategory("Gaming", systemImage: "gamecontroller"),
        SymbolCategory("Connectivity", systemImage: "antenna.radiowaves.left.and.right"),
        SymbolCategory("Transportation", systemImage: "car.fill"),
        SymbolCategory("Automotive", systemImage: "steeringwheel"),
        SymbolCategory("Accessibility", systemImage: "accessibility"),
        SymbolCategory("Privacy and Security", systemImage: "lock"),
        SymbolCategory("Human", systemImage: "person.crop.circle"),
        SymbolCategory("Home", systemImage: "house"),
        SymbolCategory("Fitness", systemImage: "figure.run"),
        SymbolCategory("Nature", systemImage: "leaf"),
        SymbolCategory("Editing", systemImage: "slider.horizontal.3"),
        SymbolCategory("Text Formatting", systemImage: "textformat"),
        SymbolCategory("Media", systemImage: "playpause"),
        SymbolCategory("Keyboard", systemImage: "command"),
        SymbolCategory("Commerce", systemImage: "cart"),
        SymbolCategory("Time", systemImage: "timer"),
        SymbolCategory("Health", systemImage: "heart"),
        SymbolCategory("Shapes", systemImage: "square.on.circle"),
        SymbolCategory("Arrows", systemImage: "arrow.forward"),
        SymbolCategory("Indices", systemImage: "a.circle"),
        SymbolCategory("Math", systemImage: "x.squareroot")
    ]
        .map({ (formatKey($0.name), $0) }))
    
    private static func formatKey(_ key: String) -> String {
        key.replacingOccurrences(of: "[^a-zA-Z0-9]", with: "", options: .regularExpression).lowercased()
    }
    
    public init(_ name: String, systemImage: String, isMember: @escaping @Sendable (Symbol) -> Bool) {
        self.name = name
        self.systemImage = systemImage
        self.isMember = isMember
    }
    
    public init (_ name: String, systemImage: String) {
        self.init(name,
                  systemImage: systemImage,
                  isMember: { symbol in symbol.categories.contains(where: { $0.name == name }) })
    }
    
    let name: String
    let systemImage: String
    private let isMember: @Sendable (Symbol) -> Bool
    
    public func isMember(_ symbol: Symbol) -> Bool {
        isMember(symbol)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
