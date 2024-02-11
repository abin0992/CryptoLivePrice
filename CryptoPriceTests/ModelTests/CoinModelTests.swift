//
//  CoinModelTests.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

@testable import CryptoPrice
import Foundation
import XCTest

class CoinModelTests: XCTestCase {

    func testCoinModelInitialization() {
        let sparkline = SparklineIn7D(price: [1.0, 2.0, 3.0])
        let coin = CoinModel(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "image_url",
            currentPrice: 10000,
            marketCap: 200000000,
            marketCapRank: 1,
            fullyDilutedValuation: nil,
            totalVolume: nil,
            high24H: nil,
            low24H: nil,
            priceChange24H: nil,
            priceChangePercentage24H: nil,
            marketCapChange24H: nil,
            marketCapChangePercentage24H: nil,
            circulatingSupply: nil,
            totalSupply: nil,
            maxSupply: nil,
            ath: nil,
            athChangePercentage: nil,
            athDate: nil,
            atl: nil,
            atlChangePercentage: nil,
            atlDate: nil,
            lastUpdated: "2020-01-01T00:00:00Z",
            sparklineIn7D: sparkline,
            priceChangePercentage24HInCurrency: nil,
            currentHoldings: 1.5
        )

        XCTAssertEqual(coin.id, "bitcoin")
        XCTAssertEqual(coin.name, "Bitcoin")
        XCTAssertEqual(coin.currentPrice, 10000)
        XCTAssertEqual(coin.marketCap, 200000000)
        XCTAssertEqual(coin.sparklineIn7D?.price?.count, 3)
        XCTAssertEqual(coin.currentHoldingsValue, 15000)
        XCTAssertEqual(coin.rank, 1)
    }
}
