
import SwiftUI

class MoreInfoViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var metadata: [String: String] = [:]
    
    private let cryptoId: Int
    
    init(cryptoId: Int) {
        self.cryptoId = cryptoId
    }
    
    func fetchCryptoMetaData() {
        Task { @MainActor in
            self.isLoading = true
            
            let cryptoMetaData: CryptocurrencyMetaData = try await APIClient.shared.request(
                endpoint: "/v2/cryptocurrency/info",
                parameters: ["id": "\(cryptoId)"]
            )
            
            try? await Task.sleep(for: .seconds(1.5))
            
            if let cryptoUrls = cryptoMetaData.data.first?.value.urls {
                self.metadata = [
                    "Website": cryptoUrls.website?.first ?? "Unknown",
                    "Technical doc": cryptoUrls.technicalDoc?.first ?? "Unknown",
                    "Twitter": cryptoUrls.twitter?.first ?? "Unknown",
                    "Reddit": cryptoUrls.reddit?.first ?? "Unknown",
                    "Message Board": cryptoUrls.messageBoard?.first ?? "Unknown",
                    "Chat": cryptoUrls.chat?.first ?? "Unknown",
                    "Explorer": cryptoUrls.explorer?.first ?? "Unknown",
                    "Source Code": cryptoUrls.sourceCode?.first ?? "Unknown"
                ]
            }
            
            withAnimation {
                self.isLoading = false
            }
            
            print(self.metadata)
        }
    }
}
