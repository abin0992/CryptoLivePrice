//
//  CryptoService.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Combine
import Foundation

protocol CryptoFetchable {
    func fetchCryptoPrices(page: String) -> AnyPublisher<[CoinModel], Error>
    func fetchCryptoDetails(coinId: String) -> AnyPublisher<CoinDetailModel, Error>
}

final class CryptoService: CryptoFetchable {

    private lazy var decoder = JSONDecoder()

    private let config: CryptoNetworkConfigurable = CryptoUrlConfig.shared

    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func fetchCryptoPrices(page: String) -> AnyPublisher<[CoinModel], Error> {
        httpClient.performRequest(
            url: CryptoUrlConfig.shared.fetchCryptoPrices(page: page).url,
            method: .get,
            body: nil
        )
        .decode(type: [CoinModel].self, decoder: decoder)
        .eraseToAnyPublisher()
    }

    func fetchCryptoDetails(coinId: String) -> AnyPublisher<CoinDetailModel, Error> {
        httpClient.performRequest(
            url: CryptoUrlConfig.shared.fetchCryptoDetails(coinId: coinId).url,
            method: .get,
            body: nil
        )
        .decode(type: CoinDetailModel.self, decoder: decoder)
        .eraseToAnyPublisher()
    }
}
