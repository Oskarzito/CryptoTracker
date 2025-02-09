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
                    
                    
                    Section(header: listHeader) {
                        ForEach(mainViewModel.filteredCurrencies) { crypto in
                            NavigationLink(value: crypto) {
                                HStack {
                                    Text("\(crypto.name) (\(crypto.symbol))")
                                    Spacer()
                                    if mainViewModel.isFavorite(id: crypto.id) {
                                        Image(systemName: "star.fill")
                                    }
                                }
                            }
                            .swipeActions(edge: .leading) {
                                // Only show "add favorite" swipe action for non-favorites
                                if !mainViewModel.isFavorite(id: crypto.id) {
                                    Button {
                                        mainViewModel.setFavorite(for: crypto.id, isFavorite: true)
                                    } label: {
                                        Image(systemName: "star.fill")
                                    }
                                    .tint(Color.yellow)
                                    
                                } else {
                                    EmptyView()
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                // Only show "remove favorite" swipe action for favorites
                                if mainViewModel.isFavorite(id: crypto.id) {
                                    Button {
                                        mainViewModel.setFavorite(for: crypto.id, isFavorite: false)
                                    } label: {
                                        Image(systemName: "star.slash.fill")
                                    }
                                    .tint(Color.red)
                                } else {
                                    EmptyView()
                                }
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
                .overlay {
                    if mainViewModel.filteredCurrencies.isEmpty {
                        ContentUnavailableView(
                            "No results found",
                            systemImage: "magnifyingglass"
                        )
                    }
                }
            }
            .navigationTitle("Crypto Market")
        }
        .searchable(text: $mainViewModel.searchText)
    }
    
    private var listHeader: some View {
        HStack {
            Toggle(isOn: $mainViewModel.showFavorites) {
                Text(
                    mainViewModel.showFavorites ? "Favorite currencies" : "All currencies")
                .font(.headline)
                .fontWeight(.regular)
            }
        }
        .textCase(nil)
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
        .environmentObject(
            MainViewModel(cryptoList: MainViewModel.dummyData, isDebug: true)
        )
}
