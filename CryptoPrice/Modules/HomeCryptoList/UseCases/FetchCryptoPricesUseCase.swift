//
//  FetchCryptoPricesUseCase.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Combine
import Foundation

protocol FetchCryptoPricesUseCaseProtocol {
    func execute(page: String) -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never>
}

final class FetchCryptoPricesUseCase: FetchCryptoPricesUseCaseProtocol {

    private let cryptoService: CryptoFetchable

    init(cryptoService: CryptoFetchable) {
        self.cryptoService = cryptoService
    }

    func execute(page: String) -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never> {
        cryptoService
            .fetchCryptoPrices(page: page)
            .receive(on: DispatchQueue.main)
            .map { $0.map(CoinViewModelFactory.createViewModel(from:)) }
            .map(DomainResult<[CoinRowViewModel]>.success)
            .catch { error in
                Just(.error(error))
            }
            .eraseToAnyPublisher()
    }
}

// MARK: For preview
final class PreviewFetchCryptoPricesUseCase: FetchCryptoPricesUseCaseProtocol {
    func execute(page: String) -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never> {
        Just([CoinViewModelFactory.createViewModel(from: DeveloperPreview.coin)])
            .map(DomainResult<[CoinRowViewModel]>.success)
            .eraseToAnyPublisher()
    }
}
