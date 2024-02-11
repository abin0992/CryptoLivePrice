//
//  CoinRowViewModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation

struct CoinRowViewModel: Identifiable, Hashable {
    let id: String
    let name: String
    let rank: String
    let symbol: String
    let image: String
    let currentPrice: String
    let priceChangePercentage24H: String
    let priceChangePercentage24HValue: Double?
    let marketCap: String
    let totalVolume: String
    let high24H: String
    let low24H: String
    let priceChange24H: String
    let marketCapChange24H: String
    let marketCapChangePercentage24H: Double?
    let lastUpdated: String
    let sparklineIn7D: SparklineIn7D?
}

extension CoinRowViewModel: Equatable {
    static func == (lhs: CoinRowViewModel, rhs: CoinRowViewModel) -> Bool {
        lhs.id == rhs.id
    }
}
