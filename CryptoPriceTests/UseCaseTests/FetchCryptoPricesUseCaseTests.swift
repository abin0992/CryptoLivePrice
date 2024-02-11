//
//  FetchCryptoPricesUseCaseTests.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import XCTest

final class FetchCryptoPricesUseCaseTests: XCTestCase {

    private var mockCryptoService: MockCryptoService!
    private var fetchCryptoPricesUseCase: FetchCryptoPricesUseCase!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockCryptoService = MockCryptoService()
        fetchCryptoPricesUseCase = FetchCryptoPricesUseCase(
            cryptoService: mockCryptoService
        )
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        mockCryptoService = nil
        fetchCryptoPricesUseCase = nil
        super.tearDown()
    }

    func testExecuteSuccess() {
        // Given
        let stubCoinList: [CoinModel] = TestUtilities.load(
            fromJSON: "crypto_price_sample",
            type: [CoinModel].self
        )

        let responsePublisher = Just(stubCoinList)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        mockCryptoService.stubbedFetchCryptoPricesResult = responsePublisher

        // When
        let expectation = XCTestExpectation(description: "execute should return success with product view models")
        fetchCryptoPricesUseCase.execute(page: "")
            .sink(
                receiveValue: { domainResult in
                    if case .success(let coins) = domainResult {
                        XCTAssertEqual(coins.count, stubCoinList.count)
                        XCTAssertEqual(coins.first?.id, stubCoinList.first?.id)
                        expectation.fulfill()
                    }
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }

    func testExecuteFailure() {
        // Given
        let responsePublisher = Fail<[CoinModel], Error>(error: ClientError.networkError)
            .eraseToAnyPublisher()
        mockCryptoService.stubbedFetchCryptoPricesResult = responsePublisher

        // When
        let expectation = XCTestExpectation(description: "execute should return error")
        fetchCryptoPricesUseCase
            .execute(page: "")
            .sink(
                receiveValue: { domainResult in
                    if case .error(let error) = domainResult, case ClientError.networkError = error {
                        expectation.fulfill()
                    }
                }
            )
            .store(in: &cancellables)

        // Then
        wait(for: [expectation], timeout: 1.0)
    }
}
