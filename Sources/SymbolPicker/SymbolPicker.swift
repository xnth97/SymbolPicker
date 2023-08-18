//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 2/14/22.
//

import SwiftUI

/// A simple and cross-platform SFSymbol picker for SwiftUI.
public struct SymbolPicker<Data: RandomAccessCollection>: View where Data.Element == Symbol {

    // MARK: - Static consts

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
        return Color(UIColor.systemGroupedBackground)
        #else
        return .clear
        #endif
    }

    private let symbols: Data
    
    // MARK: - Properties
    
    @Binding public var selection: Symbol?
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss

    private let nullable: Bool

    // MARK: - Public Init
    
    /// Initializes `SymbolPicker` with a nullable string binding that captures the raw value of
    /// user-selected _SF Symbol_. `nil` if no symbol is selected.
    ///
    /// - Parameter selection: Optional `Symbol` binding to store user selection.
    /// - Parameter symbols: A collection of _SF Symbol_ identifiers.
    public init(selection: Binding<Symbol?>, symbols: Data) {
        self._selection = selection
        self.nullable = true
        self.symbols = symbols
    }
    
    /// Initializes `SymbolPicker` with a symbol binding that captures the user-selected _SF Symbol_.
    ///
    /// - Parameter selection: `Symbol` binding to store user selection.
    /// - Parameter symbols: A collection of _SF Symbol_ identifiers.
    public init(selection: Binding<Symbol>, symbols: Data) {
        self._selection = .init { selection.wrappedValue } set: {
            guard let value = $0 else { return }
            selection.wrappedValue = value
        }
        self.nullable = false
        self.symbols = symbols
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
                ForEach(symbols.filter { searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchText) }) { symbol in
                    Button {
                        selection = symbol
                        dismiss()
                    } label: {
                        // Account for selection.
                        let isSelected = symbol == selection
                        // Render the symbol.
                        Image(systemName: symbol.name)
                            .font(.system(size: Self.symbolSize))
                            #if os(tvOS)
                            .frame(
                                minWidth: isSelected ? Self.gridDimension : nil,
                                maxWidth: isSelected ? nil : .infinity,
                                minHeight: Self.gridDimension
                            )
                            #else
                            .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                            #endif
                            .background(
                                isSelected
                                    ? Self.selectedItemBackgroundColor
                                    : Self.unselectedItemBackgroundColor
                            )
                            .cornerRadius(Self.symbolCornerRadius)
                            .foregroundColor(isSelected ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    #if os(iOS)
                    .hoverEffect(.lift)
                    #endif
                }
            }
            .padding(.horizontal)

            #if os(iOS)
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
            selection = nil
            dismiss()
        } label: {
            Label(LocalizedString("remove_symbol"), systemImage: "trash")
                #if !os(tvOS) && !os(macOS)
                .frame(maxWidth: .infinity)
                #endif
                #if !os(watchOS)
                .padding(.vertical, 12.0)
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

                #if os(iOS)
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
                    Button(LocalizedString("cancel")) {
                        dismiss()
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
        nullable && selection != nil
    }
}

public extension SymbolPicker where Data == [Symbol] {
    /// Initializes `SymbolPicker` with a symbol binding that captures the user-selected _SF Symbol_.
    ///
    /// - Parameter selection: `Symbol` binding to store user selection.
    init(selection: Binding<Symbol>) {
        self.init(selection: selection, symbols: Symbol.allCases)
    }
    
    /// Initializes `SymbolPicker` with a symbol binding that captures the user-selected _SF Symbol_.
    ///
    /// - Parameter selection: Optional `Symbol` binding to store user selection.
    init(selection: Binding<Symbol?>) {
        self.init(selection: selection, symbols: Symbol.allCases)
    }

    /// Initializes `SymbolPicker` with a nullable string binding that captures the raw value of
    /// user-selected SFSymbol. `nil` if no symbol is selected.
    ///
    /// - Parameter symbol: Optional string binding to store user selection.
    @available(*, deprecated, message: "use a `Symbol` binding instead")
    init(symbol: Binding<String?>) {
        self.init(selection: .init {
            symbol.wrappedValue.flatMap(Symbol.init(uncheckedName:))
        } set: {
            symbol.wrappedValue = $0?.id
        })
    }
    
    /// Initializes `SymbolPicker` with a string binding that captures the raw value of
    /// user-selected SFSymbol.
    ///
    /// - Parameter selection: String binding to store user selection.
    @available(*, deprecated, message: "use a `Symbol` binding instead")
    init(symbol: Binding<String>) {
        self.init(selection: .init {
            .init(uncheckedName: symbol.wrappedValue)
        } set: {
            symbol.wrappedValue = $0.id
        })
    }
}

private func LocalizedString(_ key: String) -> String {
    NSLocalizedString(key, bundle: .module, comment: "")
}

struct SymbolPicker_Previews: PreviewProvider {
    @State static var symbol: Symbol? = "square.and.arrow.up"

    static var previews: some View {
        Group {
            SymbolPicker(selection: Self.$symbol)
            SymbolPicker(selection: Self.$symbol)
                .preferredColorScheme(.dark)
        }
    }
}
