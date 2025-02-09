//
//  APIClient.swift
//  Crypto
//
//  Created by Oskar Emilsson on 2025-02-04.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case invalidData
    case decodingError
}

struct APIClient {
    
    private let url: String = "https://pro-api.coinmarketcap.com"
    private let apiKey: String = "[API-KEY-HERE]"
    
    static let shared = APIClient()
    
    private init() {}
    
    func request<T: Codable>(endpoint: String, parameters: [String: String] = [:]) async throws -> T {
        guard var urlComponents = URLComponents(string: url + endpoint) else {
            throw APIError.invalidURL
        }
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            print("HTTP Error: \(httpResponse.description)")
            throw APIError.requestFailed
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)") // For debugging
            throw APIError.decodingError
        }
    }
}
