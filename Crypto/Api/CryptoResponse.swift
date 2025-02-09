
import Foundation

// MARK: - General Market data
struct Cryptocurrency: Codable, Identifiable, Hashable {
    let id: Int
    let rank: Int
    let name: String
    let symbol: String
    let slug: String
    let isActive: Int
    let firstHistoricalData: String
    let lastHistoricalData: String
    let platform: Platform?

    enum CodingKeys: String, CodingKey {
        case id
        case rank
        case name
        case symbol
        case slug
        case isActive = "is_active"
        case firstHistoricalData = "first_historical_data"
        case lastHistoricalData = "last_historical_data"
        case platform
    }
}

struct Platform: Codable, Hashable {
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let tokenAddress: String? // Token address can be null

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case symbol
        case slug
        case tokenAddress = "token_address"
    }
}

struct Status: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed: Int
    let creditCount: Int

    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
    }
}

struct CryptoData: Codable {
    let data: [Cryptocurrency]
    let status: Status

    enum CodingKeys: String, CodingKey {
        case data, status
    }
}

// MARK: - Detailed data for specific coins
struct CryptocurrencyListing: Codable {
    let data: [String: CryptocurrencyData]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct CryptocurrencyData: Codable {
    let id: Int
    let name: String
    let symbol: String
    let tags: [String]
    let quote: Quote
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol, tags, quote
    }
}

struct Quote: Codable {
    let USD: CurrencyQuote?
    let SEK: CurrencyQuote?
    
    enum CodingKeys: String, CodingKey {
        case USD, SEK
    }
}

struct CurrencyQuote: Codable {
    let price: Double
    let percentChange1h: Double
    let percentChange24h: Double
    let percentChange7d: Double
    let percentChange30d: Double
    let percentChange60d: Double
    let percentChange90d: Double
    let marketCap: Double
    
    enum CodingKeys: String, CodingKey {
        case price
        case percentChange1h = "percent_change_1h"
        case percentChange24h = "percent_change_24h"
        case percentChange7d = "percent_change_7d"
        case percentChange30d = "percent_change_30d"
        case percentChange60d = "percent_change_60d"
        case percentChange90d = "percent_change_90d"
        case marketCap = "market_cap"
    }
}

// MARK: - Metadata for a specific coin
struct CryptocurrencyMetaData: Codable {
    let data: [String: Coin]
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Coin: Codable {
    let urls: CoinURLS
    let logoUrl: String
    let id: Int
    let name: String
    let symbol: String
    let slug: String
    let description: String
    let dateAdded: String
    let dateLaunched: String?
    let tags: [String]
    let platform: String?
    let category: String

    enum CodingKeys: String, CodingKey {
        case urls
        case logoUrl = "logo"
        case id
        case name
        case symbol
        case slug
        case description
        case dateAdded = "date_added"
        case dateLaunched = "date_launched"
        case tags
        case platform
        case category
    }
}

struct CoinURLS: Codable {
    let website: [String]?
    let technicalDoc: [String]?
    let twitter: [String]?
    let reddit: [String]?
    let messageBoard: [String]?
    let announcement: [String]?
    let chat: [String]?
    let explorer: [String]?
    let sourceCode: [String]?

    enum CodingKeys: String, CodingKey {
        case website
        case twitter
        case reddit
        case announcement
        case chat
        case explorer
        case technicalDoc = "technical_doc"
        case messageBoard = "message_board"
        case sourceCode = "source_code"
    }
}
