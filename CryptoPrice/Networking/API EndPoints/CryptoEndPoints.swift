//
//  CryptoEndPoints.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation

protocol CryptoNetworkConfigurable {
    func fetchCryptoPrices(page: String) -> URLConfig
}

struct CryptoUrlConfig: CryptoNetworkConfigurable {

    static let shared: CryptoUrlConfig = CryptoUrlConfig()

    func fetchCryptoPrices(page: String) -> URLConfig {
        Endpoint(
            path: "/api/v3/coins/markets",
            queryItems: [
                URLQueryItem(name: "vs_currency", value: "usd"),
                URLQueryItem(name: "order", value: "market_cap_desc"),
                URLQueryItem(name: "per_page", value: "200"),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "sparkline", value: "true"),
                URLQueryItem(name: "price_change_percentage", value: "24h")
            ]
        )
    }

    func fetchCryptoDetails(coinId: String) -> URLConfig {
        Endpoint(
            path: "/api/v3/coins/\(coinId)",
            queryItems: [
                URLQueryItem(name: "localization", value: "false"),
                URLQueryItem(name: "tickers", value: "false"),
                URLQueryItem(name: "market_data", value: "false"),
                URLQueryItem(name: "community_data", value: "false"),
                URLQueryItem(name: "developer_data", value: "false"),
                URLQueryItem(name: "sparkline", value: "false")
            ]
        )
    }
}
