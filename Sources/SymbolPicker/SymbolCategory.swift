//
//  SymbolCategory.swift
//  SymbolPicker
//
//  Created by Leonardo Larrañaga on 1/30/25.
//

import Foundation

/// Extension to provide all cases of `SymbolCategory`.
extension [SymbolCategory] {
    public static let all = SymbolCategory.allCases
}

/// `SymbolCategory` is an enum that represents the categories of SF Symbols.
public enum SymbolCategory: String, CaseIterable, Sendable {
//    case all
    case whatsnew
    case multicolor
    case variablecolor
    case communication
    case weather
    case maps
    case objectsandtools
    case devices
    case cameraandphotos
    case gaming
    case connectivity
    case transportation
    case automotive
    case accessibility
    case privacyandsecurity
    case human
    case home
    case fitness
    case nature
    case editing
    case textformatting
    case media
    case keyboard
    case commerce
    case time
    case health
    case shapes
    case arrows
    case indices
    case math
    
    var name: String {
        switch self {
//        case .all:
//            "All"
        case .whatsnew:
            "What's New"
        case .multicolor:
            "Multicolor"
        case .variablecolor:
            "Variable Color"
        case .communication:
            "Communication"
        case .weather:
            "Weather"
        case .maps:
            "Maps"
        case .objectsandtools:
            "Objects and Tools"
        case .devices:
            "Devices"
        case .cameraandphotos:
            "Camera and Photos"
        case .gaming:
            "Gaming"
        case .connectivity:
            "Connectivity"
        case .transportation:
            "Transportation"
        case .automotive:
            "Automotive"
        case .accessibility:
            "Accessibility"
        case .privacyandsecurity:
            "Privacy and Security"
        case .human:
            "Human"
        case .home:
            "Home"
        case .fitness:
            "Fitness"
        case .nature:
            "Nature"
        case .editing:
            "Editing"
        case .textformatting:
            "Text Formatting"
        case .media:
            "Media"
        case .keyboard:
            "Keyboard"
        case .commerce:
            "Commerce"
        case .time:
            "Time"
        case .health:
            "Health"
        case .shapes:
            "Shapes"
        case .arrows:
            "Arrows"
        case .indices:
            "Indices"
        case .math:
            "Math"
        }
    }
    
    var systemImage: String {
        switch self {
//        case .all:
//            "square.grid.2x2"
        case .whatsnew:
            "sparkles"
        case .multicolor:
            "paintpalette"
        case .variablecolor:
            "slider.horizontal.below.square.and.square.filled"
        case .communication:
            "message"
        case .weather:
            "cloud.sun"
        case .maps:
            "map"
        case .objectsandtools:
            "folder"
        case .devices:
            "desktopcomputer"
        case .cameraandphotos:
            "camera"
        case .gaming:
            "gamecontroller"
        case .connectivity:
            "antenna.radiowaves.left.and.right"
        case .transportation:
            "car.fill"
        case .automotive:
            "steeringwheel"
        case .accessibility:
            "accessibility"
        case .privacyandsecurity:
            "lock"
        case .human:
            "person.crop.circle"
        case .home:
            "house"
        case .fitness:
            "figure.run"
        case .nature:
            "leaf"
        case .editing:
            "slider.horizontal.3"
        case .textformatting:
            "textformat"
        case .media:
            "playpause"
        case .keyboard:
            "command"
        case .commerce:
            "cart"
        case .time:
            "timer"
        case .health:
            "heart"
        case .shapes:
            "square.on.circle"
        case .arrows:
            "arrow.forward"
        case .indices:
            "a.circle"
        case .math:
            "x.squareroot"
        }
    }
}
