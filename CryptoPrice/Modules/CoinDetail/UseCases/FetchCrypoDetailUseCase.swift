//
//  FetchCrypoDetailUseCase.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
import Foundation

protocol FetchCrypoDetailUseCaseProtocol {
    func execute(coinId: String) -> AnyPublisher<DomainResult<CoinDetailModel>, Never>
}

final class FetchCrypoDetailUseCase: FetchCrypoDetailUseCaseProtocol {

    private let cryptoService: CryptoFetchable

    init(cryptoService: CryptoFetchable) {
        self.cryptoService = cryptoService
    }

    func execute(coinId: String) -> AnyPublisher<DomainResult<CoinDetailModel>, Never> {
        cryptoService
            .fetchCryptoDetails(coinId: coinId)
            .receive(on: DispatchQueue.main)
            .map(DomainResult<CoinDetailModel>.success)
            .catch { error in
                Just(.error(error))
            }
            .eraseToAnyPublisher()
    }
}

// MARK: For preview
final class PreviewFetchCrypoDetailUseCase: FetchCrypoDetailUseCaseProtocol {
    func execute(coinId: String) -> AnyPublisher<DomainResult<CoinDetailModel>, Never> {
        Just(
            CoinDetailModel(
                id: "",
                symbol: "",
                name: "",
                blockTimeInMinutes: nil,
                hashingAlgorithm: nil,
                description: nil,
                links: nil
            )
        )
        .map(DomainResult<CoinDetailModel>.success)
        .eraseToAnyPublisher()
    }
}
