//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 2/14/22.
//

import SwiftUI

#if os(macOS)
import AppKit
typealias PlatformColor = NSColor
#else
import UIKit
typealias PlatformColor = UIColor
#endif

public struct SymbolPicker: View {

    // MARK: - Static consts

    private static let symbols: [String] = {
        guard let path = Bundle.module.path(forResource: "sfsymbols", ofType: "txt"),
              let content = try? String(contentsOfFile: path)
        else {
            return []
        }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }()

    private static var gridDimension: CGFloat {
        #if os(iOS)
            return 64
        #elseif os(tvOS)
            return 128
        #elseif os(macOS)
            return 30
        #else
            return 48
        #endif
    }

    private static var symbolSize: CGFloat {
        #if os(iOS)
            return 24
        #elseif os(tvOS)
            return 48
        #elseif os(macOS)
            return 14
        #else
            return 24
        #endif
    }

    private static var symbolCornerRadius: CGFloat {
        #if os(iOS)
            return 8
        #elseif os(tvOS)
            return 12
        #elseif os(macOS)
            return 4
        #else
            return 8
        #endif
    }

    private static var systemGray5: Color {
        dynamicColor(
            light: .init(red: 0.9, green: 0.9, blue: 0.92, alpha: 1.0),
            dark: .init(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.0)
        )
    }

    private static var systemBackground: Color {
        dynamicColor(
            light: .init(red: 1, green: 1, blue: 1, alpha: 1.0),
            dark: .init(red: 0, green: 0, blue: 0, alpha: 1.0)
        )
    }

    private static var secondarySystemBackground: Color {
        dynamicColor(
            light: .init(red: 0.95, green: 0.95, blue: 1, alpha: 1.0),
            dark: .init(red: 0, green: 0, blue: 0, alpha: 1.0)
        )
    }

    // MARK: - Properties

    @Binding public var symbol: String
    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Public Init

    public init(symbol: Binding<String>) {
        _symbol = symbol
    }

    // MARK: - View Components

    @ViewBuilder
    private var searchableSymbolGrid: some View {
        #if os(iOS)
            if #available(iOS 15.0, *) {
                symbolGrid
                    .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            } else {
                VStack {
                    TextField(LocalizedString("search_placeholder"), text: $searchText)
                        .padding(8)
                        .padding(.horizontal, 8)
                        .background(Self.systemGray5)
                        .cornerRadius(8.0)
                        .padding(.horizontal, 16.0)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    symbolGrid
                        .padding()
                }
            }
        #elseif os(tvOS)
            symbolGrid
                .searchable(text: $searchText, placement: .automatic)
        #elseif os(macOS)
            VStack(spacing: 10) {
                TextField(LocalizedString("search_placeholder"), text: $searchText)
                    .disableAutocorrection(true)
                symbolGrid
            }
        #else
        symbolGrid
            .searchable(text: $searchText, placement: .automatic)
        #endif
    }

    private var symbolGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                ForEach(Self.symbols.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { thisSymbol in
                    Button(action: {
                        symbol = thisSymbol

                        // Dismiss sheet. macOS will have done button
                        #if !os(macOS)
                        presentationMode.wrappedValue.dismiss()
                        #endif
                    }) {
                        if thisSymbol == symbol {
                            Image(systemName: thisSymbol)
                                .font(.system(size: Self.symbolSize))
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                            #if !os(tvOS)
                                .background(Color.accentColor)
                            #else
                                .background(Color.gray.opacity(0.3))
                            #endif
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: thisSymbol)
                                .font(.system(size: Self.symbolSize))
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                .background(Self.systemBackground)
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

    public var body: some View {
        #if !os(macOS)
            NavigationView {
                ZStack {
                    Self.secondarySystemBackground.edgesIgnoringSafeArea(.all)
                    searchableSymbolGrid
                }
                #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
                #endif
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button(LocalizedString("cancel")) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        #else
            VStack(alignment: .leading, spacing: 10) {
                Text(LocalizedString("sf_symbol_picker"))
                    .font(.headline)
                Divider()
                searchableSymbolGrid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider()
                HStack {
                    Button {
                        symbol = ""
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(LocalizedString("cancel"))
                    }
                    .keyboardShortcut(.cancelAction)
                    Spacer()
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text(LocalizedString("done"))
                    }
                }
            }
            .padding()
            .frame(width: 520, height: 300, alignment: .center)
        #endif
    }

    // MARK: - Private helpers

    private static func dynamicColor(light: PlatformColor, dark: PlatformColor) -> Color {
        #if os(iOS)
            let color = PlatformColor { $0.userInterfaceStyle == .dark ? dark : light }
            if #available(iOS 15.0, *) {
                return Color(uiColor: color)
            } else {
                return Color(color)
            }
        #elseif os(tvOS)
            let color = PlatformColor { $0.userInterfaceStyle == .dark ? dark : light }
            return Color(uiColor: color)
        #elseif os(macOS)
            let color = PlatformColor(name: nil) { $0.name == .darkAqua ? dark : light }
            if #available(macOS 12.0, *) {
                return Color(nsColor: color)
            } else {
                return Color(color)
            }
        #else
            return Color(uiColor: dark)
        #endif
    }

}

private func LocalizedString(_ key: String) -> String {
    NSLocalizedString(key, bundle: .module, comment: "")
}

struct SymbolPicker_Previews: PreviewProvider {
    @State static var symbol: String = "square.and.arrow.up"

    static var previews: some View {
        Group {
            SymbolPicker(symbol: Self.$symbol)
            SymbolPicker(symbol: Self.$symbol)
                .preferredColorScheme(.dark)
        }
    }
}
