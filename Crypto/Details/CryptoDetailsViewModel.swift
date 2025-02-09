
import SwiftUI

enum CryptoTimeInterval: String, CaseIterable {
    case time1h = "1h"
    case time24h = "24h"
    case time7d = "7d"
    case time30d = "30d"
    case time90d = "90d"
    
    var longName: String {
        switch self {
        case .time1h: return "1 Hour"
        case .time24h: return "24 Hours"
        case .time7d: return "7 Days"
        case .time30d: return "30 Days"
        case .time90d: return "90 Days"
        }
    }
}

class CryptoDetailsViewModel: ObservableObject {
    
    let cryptocurrency: Cryptocurrency
    
    @Published var isLoading: Bool = true
    @Published var cryptoListing: CryptocurrencyData?
    @Published var selectedTimeInterval: CryptoTimeInterval = .time1h
    @Published var percentageChange: Double = 0
    
    let timeIntervals: [CryptoTimeInterval] = CryptoTimeInterval.allCases
    
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = ""
        return formatter
    }()
    
    init(cryptocurrency: Cryptocurrency) {
        self.cryptocurrency = cryptocurrency
    }
    
    func fetchCryptoData(for currency: String) {
        Task { @MainActor in
            self.isLoading = true
            
            let cryptoDetails: CryptocurrencyListing = try await APIClient.shared.request(
                endpoint: "/v1/cryptocurrency/quotes/latest",
                parameters: [
                    "id": "\(cryptocurrency.id)",
                    "convert": currency
                ]
            )
            
            try? await Task.sleep(for: .seconds(1.5))
            
            let cryptoCurrencyData = cryptoDetails.data.first?.value
            self.cryptoListing = cryptoCurrencyData
            
            let quoteForCurrency = quote(for: currency)
            self.percentageChange = quoteForCurrency?.percentChange1h ?? 0
            
            withAnimation {
                self.isLoading = false
            }
            
            
            print("Name: \(String(describing: cryptoListing?.name)), Symbol: \(String(describing: cryptoListing?.symbol)), Quote: \(String(describing: cryptoListing?.quote))")
        }
    }
    
    func updatePercentageChange(for currency: String) {
        let quoteForCurrency = quote(for: currency)
        
        switch selectedTimeInterval {
        case .time1h:
            self.percentageChange = quoteForCurrency?.percentChange1h ?? 0
        case .time24h:
            self.percentageChange = quoteForCurrency?.percentChange24h ?? 0
        case .time7d:
            self.percentageChange = quoteForCurrency?.percentChange7d ?? 0
        case .time30d:
            self.percentageChange = quoteForCurrency?.percentChange30d ?? 0
        case .time90d:
            self.percentageChange = quoteForCurrency?.percentChange90d ?? 0
        }
    }
    
    func formattedPrice(currency: String) -> String {
        let quoteForCurrency = quote(for: currency)
        
        guard let price: Double = quoteForCurrency?.price else {
            return "Unknown"
        }
        return formatter.string(from: NSNumber(value: price)) ?? "Unknown"
    }
    
    func marketCap(currency: String) -> String {
        let quoteForCurrency = quote(for: currency)
        return formatter.string(from: NSNumber(value: quoteForCurrency?.marketCap ?? 0)) ?? "Unknown"
    }
    
    private func quote(for currency: String) -> CurrencyQuote? {
        switch currency {
        case "USD":
            return cryptoListing?.quote.USD
        case "SEK":
            return cryptoListing?.quote.SEK
        default:
            return cryptoListing?.quote.USD
        }
    }
}
