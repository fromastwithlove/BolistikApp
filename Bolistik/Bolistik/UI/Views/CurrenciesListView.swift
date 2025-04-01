//
//  CurrenciesListView.swift
//  Bolistik
//
//  Created by Adil Yergaliyev on 23.03.25.
//

import SwiftUI

struct CurrenciesListView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var selectedCurrency: String
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                let currencies = getAllCurrencies()
                let filteredCurrencies = filterCurrencies(currencies: currencies)
                
                List(filteredCurrencies, id: \.0) { (currencyCode, currencySymbol) in
                    HStack {
                        Text(verbatim:"\(currencySymbol) (\(currencyCode))")
                        Spacer()
                        if selectedCurrency == currencyCode {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedCurrency = currencyCode
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            }
        }
        .navigationTitle("Currencies")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Fetching and Filtering Currencies

extension CurrenciesListView {
    
    private func getAllCurrencies() -> [(String, String)] {
        return Locale.commonISOCurrencyCodes.compactMap { currencyCode -> (String, String)? in
            let locale = Locale.current
            // Try to get the currency symbol from the locale
            let currencySymbol = locale.localizedString(forCurrencyCode: currencyCode)
            // If no symbol is found, use the currency code itself
            let displaySymbol = currencySymbol ?? currencyCode
            return (currencyCode, displaySymbol)
        }
        .sorted { $0.1 < $1.1 }
    }
    
    private func filterCurrencies(currencies: [(String, String)]) -> [(String, String)] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter { currencyCode, currencySymbol in
                currencySymbol.lowercased().contains(searchText.lowercased()) ||
                currencyCode.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCurrency = "EUR"
    CurrenciesListView(selectedCurrency: $selectedCurrency)
}
