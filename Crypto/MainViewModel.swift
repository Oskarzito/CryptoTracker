
import SwiftUI

class MainViewModel: ObservableObject {
    private var cryptoList: [Cryptocurrency] = []
    private let isDebug: Bool
    private let favoritesRepositor = FavoritesRepository()
    
    @Published var showFavorites: Bool = false
    @Published var isLoading: Bool = true
    @Published var searchText = ""
    @Published var selectedCurrency: String = "USD"
    @Published var favorites: [Int: Bool] = [:]
    
    let currencies: [String] = ["USD", "SEK"]
    
    init(cryptoList: [Cryptocurrency] = [], isDebug: Bool = false) {
        self.cryptoList = cryptoList
        self.isDebug = isDebug
    }
    
    var filteredCurrencies: [Cryptocurrency] {
        if searchText.isEmpty {
            return cryptoList.filter { !showFavorites || (showFavorites && isFavorite(id: $0.id)) }
        } else {
            return cryptoList.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
            .filter { !showFavorites || (showFavorites && isFavorite(id: $0.id)) }
        }
    }
    
    func fetchOverviewData() {
        guard !isDebug else {
            return
        }
        Task { @MainActor in
            self.isLoading = true
            
            let cryptoList: CryptoData = try await APIClient.shared.request(endpoint: "/v1/cryptocurrency/map")
            
            try? await Task.sleep(for: .seconds(1.5))
            
            self.favorites = self.resolveFavorites(ids: cryptoList.data.map { $0.id })
            self.cryptoList = cryptoList.data
            
            withAnimation {
                self.isLoading = false
            }
            
            for crypto in cryptoList.data {
                print("Name: \(crypto.name), Symbol: \(crypto.symbol)")
            }
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        favorites[id] ?? false
    }
    
    func setFavorite(for id: Int, isFavorite: Bool) {
        favoritesRepositor.setFavorite(for: id)
        favorites[id] = isFavorite
    }
    
    private func resolveFavorites(ids: [Int]) -> [Int: Bool] {
        var favorites: [Int: Bool] = [:]
        for id in ids {
            favorites[id] = favoritesRepositor.isFavorite(for: id)
        }
        return favorites
    }
    
    static let dummyData: [Cryptocurrency] = [
        .init(id: 1, rank: 0, name: "Bitcoin", symbol: "BTC", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 2, rank: 0, name: "Ethereum", symbol: "ETH", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 4, rank: 0, name: "Ripple", symbol: "XRP", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 5, rank: 0, name: "Cardano", symbol: "ADA", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 6, rank: 0, name: "Bitcoin Plus", symbol: "XBC", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 7, rank: 0, name: "Terracoin", symbol: "TRC", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 8, rank: 0, name: "Dogecoin", symbol: "DOGE", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil),
        .init(id: 9, rank: 0, name: "Peercoin", symbol: "PPC", slug: "", isActive: 0, firstHistoricalData: "", lastHistoricalData: "", platform: nil)
    ]
}
