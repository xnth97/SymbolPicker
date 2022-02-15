//
//  SymbolPicker.swift
//  SymbolPicker
//
//  Created by Yubo Qin on 2/14/22.
//

import SwiftUI

public struct SymbolPicker: View {

    // MARK: - Static consts

    private static let symbols: [String] = {
        guard let path = Bundle.module.path(forResource: "sfsymbols", ofType: "txt"),
              let content = try? String(contentsOfFile: path) else {
                  return []
              }
        return content
            .split(separator: "\n")
            .map { String($0) }
    }()

    private static let gridDimension: CGFloat = 64.0
    private static let symbolSize: CGFloat = 24.0
    private static let symbolCornerRadius: CGFloat = 8.0

    // MARK: - Properties

    @Binding public var symbol: String
    @State private var searchText = ""
    @Environment(\.presentationMode) private var presentationMode

    // MARK: - Public Init

    public init(symbol: Binding<String>) {
        self._symbol = symbol
    }

    // MARK: - View Components

    @ViewBuilder
    private var searchableSymbolGrid: some View {
        if #available(iOS 15.0, *) {
            symbolGrid
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        } else {
            VStack {
                TextField(LocalizedString("search_placeholder"), text: $searchText)
                    .padding(8)
                    .padding(.horizontal, 8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8.0)
                    .padding(.horizontal, 16.0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                symbolGrid
            }
        }
    }

    private var symbolGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Self.gridDimension, maximum: Self.gridDimension))]) {
                ForEach(Self.symbols.filter { searchText.isEmpty ? true : $0.localizedCaseInsensitiveContains(searchText) }, id: \.self) { thisSymbol in
                    Button(action: {
                        symbol = thisSymbol
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        if thisSymbol == symbol {
                            Image(systemName: thisSymbol)
                                .font(.system(size: Self.symbolSize))
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                .background(Color.blue)
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: thisSymbol)
                                .font(.system(size: Self.symbolSize))
                                .frame(maxWidth: .infinity, minHeight: Self.gridDimension)
                                .background(Color(UIColor.systemBackground))
                                .cornerRadius(Self.symbolCornerRadius)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .padding()
        }
    }

    public var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.all)
                searchableSymbolGrid
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedString("cancel")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

}

fileprivate func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, bundle: .module, comment: "")
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
