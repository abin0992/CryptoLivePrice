//
//  CoinViewModelFactory.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation

final class CoinViewModelFactory {
    static func createViewModel(from model: CoinModel) -> CoinRowViewModel {
        let id = model.id
        let name = model.name
        let rank = "\(model.rank)"
        let symbol = model.symbol.uppercased()
        let image = model.image
        let currentPrice = model.currentPrice.asCurrencyWith6Decimals()
        let priceChangePercentage24H = model.priceChangePercentage24H?.asPercentString() ?? ""
        let priceChangePercentage24HValue = model.priceChangePercentage24H
        let marketCap = model.marketCap?.formattedWithAbbreviations() ?? ""
        let totalVolume = model.totalVolume?.formattedWithAbbreviations() ?? ""
        let high24H = model.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let low24H = model.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let priceChange24H = model.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let marketCapChange24H = model.marketCapChange24H?.formattedWithAbbreviations() ?? ""
        let marketCapChangePercentage24H = model.marketCapChangePercentage24H
        let lastUpdated = model.lastUpdated ?? ""
        let sparklineIn7D = model.sparklineIn7D

        return CoinRowViewModel(
            id: id,
            name: name,
            rank: rank,
            symbol: symbol,
            image: image,
            currentPrice: currentPrice,
            priceChangePercentage24H: priceChangePercentage24H,
            priceChangePercentage24HValue: priceChangePercentage24HValue,
            marketCap: marketCap,
            totalVolume: totalVolume,
            high24H: high24H,
            low24H: low24H,
            priceChange24H: priceChange24H,
            marketCapChange24H: marketCapChange24H,
            marketCapChangePercentage24H: marketCapChangePercentage24H,
            lastUpdated: lastUpdated,
            sparklineIn7D: sparklineIn7D
        )
    }
}
