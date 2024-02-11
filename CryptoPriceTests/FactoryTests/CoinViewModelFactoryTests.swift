//
//  CoinViewModelFactoryTests.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

@testable import CryptoPrice
import XCTest

class CoinViewModelFactoryTests: XCTestCase {

    func testCreateViewModelFromCoinModel() {
        // Given
        let model = CoinModel(
            id: "bitcoin",
            symbol: "btc",
            name: "Bitcoin",
            image: "image_url",
            currentPrice: 12345.6789,
            marketCap: nil, // Optional properties can be nil
            marketCapRank: 1,
            fullyDilutedValuation: nil,
            totalVolume: nil,
            high24H: nil,
            low24H: nil,
            priceChange24H: nil,
            priceChangePercentage24H: 12.34,
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
            lastUpdated: nil,
            sparklineIn7D: nil,
            priceChangePercentage24HInCurrency: nil,
            currentHoldings: nil
        )

        // When
        let viewModel = CoinViewModelFactory.createViewModel(from: model)

        // Then
        XCTAssertEqual(viewModel.id, "bitcoin")
        XCTAssertEqual(viewModel.rank, "1")
        XCTAssertEqual(viewModel.symbol, "BTC")
        XCTAssertEqual(viewModel.image, "image_url")
        XCTAssertEqual(viewModel.priceChangePercentage24H, "12.34%")
        XCTAssertEqual(viewModel.priceChangePercentage24HValue, 12.34)
    }
}
