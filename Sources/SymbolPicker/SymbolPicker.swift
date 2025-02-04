//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 2/14/22.
//

import SwiftUI

/// A simple and cross-platform SFSymbol picker for SwiftUI.
public struct SymbolPicker: View {

    // MARK: - Static constants

    private static var gridDimension: CGFloat {
        #if os(iOS)
        return 64
        #elseif os(tvOS)
        return 128
        #elseif os(macOS)
        return 48
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
        return 24
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
        return 8
        #else
        return 8
        #endif
    }

    private static var unselectedItemBackgroundColor: Color {
        #if os(iOS)
        return Color(UIColor.systemBackground)
        #else
        return .clear
        #endif
    }

    private static var selectedItemBackgroundColor: Color {
        #if os(tvOS)
        return Color.gray.opacity(0.3)
        #else
        return Color.accentColor
        #endif
    }

    private static var backgroundColor: Color {
        #if os(iOS)
        return Color(UIColor.secondarySystemBackground)
        #else
        return .clear
        #endif
    }

    private static var deleteButtonTextVerticalPadding: CGFloat {
        #if os(iOS)
        return 12.0
        #else
        return 8.0
        #endif
    }

    // MARK: - Properties
    
    @Binding public var symbol: String?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private let nullable: Bool
    private let categories: [SymbolCategory]

    // MARK: - Init

    /// Initializes `SymbolPicker` with a string binding to the selected symbol name and default categories to display.
    ///
    /// - Parameters:
    ///   - symbol: A binding to a `String` that represents the name of the selected symbol.
    ///     When a symbol is picked, this binding is updated with the symbol's name.
    ///   - categories: An array of `SymbolCategory` that represents the categories of the symbols to be displayed.
    ///     Default is `.all`.
    public init(symbol: Binding<String>, categories: [SymbolCategory] = .all) {
        self.init(
            symbol: Binding {
                return symbol.wrappedValue
            } set: { newValue in
                /// As the `nullable` is set to `false`, this can not be `nil`
                if let newValue {
                    symbol.wrappedValue = newValue
                }
            },
            nullable: false,
            categories: categories
        )
    }

    /// Initializes `SymbolPicker` with a nullable string binding to the selected symbol name and default categories to display.
    ///
    /// - Parameters:
    ///   - symbol: A binding to a `String` that represents the name of the selected symbol.
    ///     When a symbol is picked, this binding is updated with the symbol's name. When no symbol
    ///     is picked, the value will be `nil`.
    ///   - categories: An array of `SymbolCategory` that represents the categories of the symbols to be displayed.
    ///     Default is `.all`.
    public init(symbol: Binding<String?>, categories: [SymbolCategory] = .all) {
        self.init(symbol: symbol, nullable: true, categories: categories)
    }

    /// Private designated initializer.
    private init(symbol: Binding<String?>,
                 nullable: Bool, categories: [SymbolCategory] ) {
        self._symbol = symbol
        self.nullable = nullable
        self.categories = categories
    }

    // MARK: - View Components

    @ViewBuilder
    private var searchableSymbolGrid: some View {
        #if os(iOS)
        symbolGrid
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        #elseif os(tvOS)
        VStack {
            TextField(LocalizedString("search_placeholder"), text: $searchText)
                .padding(.horizontal, 8)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            symbolGrid
        }

        /// `searchable` is crashing on tvOS 16. What the hell aPPLE?
        ///
        /// symbolGrid
        ///     .searchable(text: $searchText, placement: .automatic)
        #elseif os(macOS)
        VStack(spacing: 0) {
            HStack {
                TextField(LocalizedString("search_placeholder"), text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 18.0))
                    .disableAutocorrection(true)

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 16.0, height: 16.0)
                }
                .buttonStyle(.borderless)
            }
            .padding()

            Divider()

            symbolGrid

            if canDeleteIcon {
                Divider()
                HStack {
                    Spacer()
                    deleteButton
                        .padding(.horizontal)
                        .padding(.vertical, 8.0)
                }
            }
        }
        #else
        symbolGrid
            .searchable(text: $searchText, placement: .automatic)
        #endif
    }

    private var symbolGrid: some View {
        ScrollView {
            #if os(tvOS) || os(watchOS)
            if canDeleteIcon {
                deleteButton
            }
            #endif

            LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                ForEach(symbols.filter {
                    (categories == .all || !$0.categories.isDisjoint(with: categories))
                    && (searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText))
                }) { thisSymbol in
                    Button {
                        symbol = thisSymbol.name
                        dismiss()
                    } label: {
                        if thisSymbol.name == symbol {
                            Image(systemName: thisSymbol.name)
                                .font(.system(size: Self.symbolSize))
                                #if os(tvOS)
                                .frame(minWidth: Self.gridDimension, minHeight: Self.gridDimension)
                                #else
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                #endif
                                .background(Self.selectedItemBackgroundColor)
                                #if os(visionOS)
                                .clipShape(Circle())
                                #else
                                .cornerRadius(Self.symbolCornerRadius)
                                #endif
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: thisSymbol.name)
                                .font(.system(size: Self.symbolSize))
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                .background(Self.unselectedItemBackgroundColor)
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.primary)
                        }
                    }
                    .buttonStyle(.plain)
                    #if os(iOS)
                    .hoverEffect(.lift)
                    #endif
                }
            }
            .padding(.horizontal)

            #if os(iOS) || os(visionOS)
            /// Avoid last row being hidden.
            if canDeleteIcon {
                Spacer()
                    .frame(height: Self.gridDimension * 2)
            }
            #endif
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) {
            symbol = nil
            dismiss()
        } label: {
            Label(LocalizedString("remove_symbol"), systemImage: "trash")
                #if !os(tvOS) && !os(macOS)
                .frame(maxWidth: .infinity)
                #endif
                #if !os(watchOS)
                .padding(.vertical, Self.deleteButtonTextVerticalPadding)
                #endif
                .background(Self.unselectedItemBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
        }
    }

    public var body: some View {
        #if !os(macOS)
        NavigationView {
            ZStack {
                #if os(iOS)
                Self.backgroundColor.edgesIgnoringSafeArea(.all)
                #endif
                searchableSymbolGrid

                #if os(iOS) || os(visionOS)
                if canDeleteIcon {
                    VStack {
                        Spacer()

                        deleteButton
                            .padding()
                            .background(.regularMaterial)
                    }
                }
                #endif
            }
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            #if !os(tvOS)
            /// tvOS can use back button on remote
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text(LocalizedString("cancel"))
                    }
                }
            }
            #endif
        }
        .navigationViewStyle(.stack)
        #else
        searchableSymbolGrid
            .frame(width: 540, height: 340, alignment: .center)
            .background(.regularMaterial)
        #endif
    }

    private var canDeleteIcon: Bool {
        nullable && symbol != nil
    }

    private var symbols: [Symbol] {
        Symbols.shared.symbols
    }

}

private func LocalizedString(_ key: String.LocalizationValue) -> String {
    String(localized: key, bundle: .module)
}

// MARK: - Debug

#if DEBUG
#Preview("Normal") {
    struct Preview: View {
        @State private var symbol: String? = "square.and.arrow.up"
        var body: some View {
            SymbolPicker(symbol: $symbol)
        }
    }
    return Preview()
}

#Preview("Filter Example") {
    Symbols.shared.filter = { $0.contains(".circle") }
    
    struct Preview: View {
        @State private var symbol: String? = "square.and.arrow.up.circle.fill"
        var body: some View {
            SymbolPicker(symbol: $symbol)
        }
    }
    return Preview()
}

#Preview("Categories Example") {
    struct Preview: View {
        @State private var symbol: String = ""
        var body: some View {
            SymbolPicker(symbol: $symbol, categories: [.maps, .math])
        }
    }
    return Preview()
}

#endif
