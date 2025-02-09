
import SwiftUI

class MainViewModel: ObservableObject {
    private var cryptoList: [Cryptocurrency] = []
    private let isDebug: Bool
    
    @Published var isLoading: Bool = true
    @Published var searchText = ""
    @Published var selectedCurrency: String = "USD"
    
    let currencies: [String] = ["USD", "SEK"]
    
    init(cryptoList: [Cryptocurrency] = [], isDebug: Bool = false) {
        self.cryptoList = cryptoList
        self.isDebug = isDebug
    }
    
    var filteredCurrencies: [Cryptocurrency] {
        if searchText.isEmpty {
            return cryptoList
        } else {
            return cryptoList.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText)
            }
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
            
            self.cryptoList = cryptoList.data
            
            withAnimation {
                self.isLoading = false
            }
            
            for crypto in cryptoList.data {
                print("Name: \(crypto.name), Symbol: \(crypto.symbol)")
            }
        }
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
