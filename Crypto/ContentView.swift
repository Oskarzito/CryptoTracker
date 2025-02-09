//
//  ContentView.swift
//  Crypto
//
//  Created by Oskar Emilsson on 2025-02-03.
//

import SwiftUI
import Lottie

struct ContentView: View {
    
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                List {
                    Picker("", selection: $mainViewModel.selectedCurrency) {
                        ForEach(mainViewModel.currencies, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                    
                    Section(header: Text("Cryptocurrencies")) {
                        ForEach(mainViewModel.filteredCurrencies) { crypto in
                            NavigationLink(value: crypto) {
                                Text("\(crypto.name) (\(crypto.symbol))")
                            }
                        }
                    }
                }
                .navigationDestination(for: Cryptocurrency.self) { cryptocurrency in
                    CryptoDetailsView()
                        .environmentObject(
                            CryptoDetailsViewModel(cryptocurrency: cryptocurrency)
                        )
                }
            }
            .navigationTitle("Crypto Market")
        }
        .searchable(text: $mainViewModel.searchText)
    }
    
    private var loader: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .tint(.white)
            .scaleEffect(1.5)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ContentView()
        .environmentObject(MainViewModel(cryptoList: MainViewModel.dummyData, isDebug: true))
}
