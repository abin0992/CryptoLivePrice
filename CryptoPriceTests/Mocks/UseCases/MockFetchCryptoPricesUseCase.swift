//
//  MockFetchCryptoPricesUseCase.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import Foundation

final class MockFetchCryptoPricesUseCase: FetchCryptoPricesUseCaseProtocol {
    var stubbedCoins: [CoinRowViewModel] = []
    var stubbedError: Error?
    private let subject = PassthroughSubject<DomainResult<[CoinRowViewModel]>, Never>()

    func execute(page: String) -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never> {
        subject.eraseToAnyPublisher()
    }

    func sendCoins() {
        subject.send(.success(stubbedCoins))
    }

    func sendError() {
        let error = stubbedError ?? ClientError.generic
        subject.send(.error(error))
    }
}
