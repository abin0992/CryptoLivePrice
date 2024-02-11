//
//  MockCryptoService.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import Foundation

final class MockCryptoService: CryptoFetchable {

    var stubbedFetchCryptoPricesResult: AnyPublisher<[CoinModel], Error>!

    func fetchCryptoPrices(page: String) -> AnyPublisher<[CoinModel], Error> {
        stubbedFetchCryptoPricesResult
    }

    var stubbedFetchCryptoDetailResult: AnyPublisher<CoinDetailModel, Error>!

    func fetchCryptoDetails(coinId: String) -> AnyPublisher<CoinDetailModel, Error> {
        stubbedFetchCryptoDetailResult
    }
}
