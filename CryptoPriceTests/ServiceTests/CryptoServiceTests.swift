//
//  CryptoServiceTests.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import XCTest

final class CryptoServiceTests: XCTestCase {

    var cryptoService: CryptoService!
    var mockHTTPClient: MockHTTPClient!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockHTTPClient = MockHTTPClient()
        cryptoService = CryptoService(httpClient: mockHTTPClient)
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        mockHTTPClient = nil
        cryptoService = nil
        super.tearDown()
    }

    func testFetchCryptoPricesSuccess() {
        // Given
        let mockResponse: [CoinModel] = TestUtilities.load(
            fromJSON: "crypto_price_sample",
            type: [CoinModel].self
        )

        let encoder = JSONEncoder()
        guard let responseData = try? encoder.encode(mockResponse) else {
            XCTFail("Failed to encode mock response")
            return
        }
        mockHTTPClient.responseData = responseData

        // Expectation
        let expectation = XCTestExpectation(description: "Fetch crypto prices completes successfully")

        // Exercise
        cryptoService.fetchCryptoPrices(page: "1")
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Expected successful completion, received a failure instead")
                }
                expectation.fulfill()
            },
            receiveValue: { coinModels in
                XCTAssertEqual(coinModels.count, mockResponse.count)
                XCTAssertEqual(coinModels.first?.id, mockResponse.first?.id)
            }
        )
        .store(in: &cancellables)

        // Verify
        wait(for: [expectation], timeout: 1.0)

    }

    func testFetchCryptoPricesFailure() {
        mockHTTPClient.error = ClientError.networkError

        // Expectation
        let expectation = XCTestExpectation(description: "Fetch crypto prices results in error")

        // Exercise
        cryptoService.fetchCryptoPrices(page: "1")
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        XCTFail("Expected failure completion, received successful completion instead")
                    case .failure(let error):
                        guard let clientError = error as? ClientError else {
                            XCTFail("Expected ClientError, received another error type")
                            return
                        }
                        XCTAssertEqual(clientError, ClientError.networkError)
                    }
                    expectation.fulfill()
                },
                receiveValue: { _ in
                    XCTFail("Expected no response, received some data instead")
                }
            )
            .store(in: &cancellables)

        // Verify
        wait(for: [expectation], timeout: 1.0)

    }
}
