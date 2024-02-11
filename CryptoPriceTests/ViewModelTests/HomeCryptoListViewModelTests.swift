//
//  HomeCryptoListViewModelTests.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import XCTest

class HomeCryptoListViewModelTests: XCTestCase {

    var viewModel: HomeCryptoListViewModel!
    var mockFetchCryptoPricesUseCase: MockFetchCryptoPricesUseCase!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockFetchCryptoPricesUseCase = MockFetchCryptoPricesUseCase()
        viewModel = HomeCryptoListViewModel(
            fetchCryptoPricesUseCase: mockFetchCryptoPricesUseCase
        )
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockFetchCryptoPricesUseCase = nil
        cancellables = nil
        super.tearDown()
    }

    func testViewModelInitialStateIsLoading() {
        XCTAssertEqual(viewModel.state, .loading)
    }

    func testViewModelFetchesCoinsOnInitialization() {
        let expectation = XCTestExpectation(description: "Fetch crypto coins on initialization")

        viewModel.$state
            .dropFirst() // Drop the initial loading state
            .sink { state in
                if case .data(let coins) = state {
                    XCTAssertEqual(coins.count, self.mockFetchCryptoPricesUseCase.stubbedCoins.count)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockFetchCryptoPricesUseCase.sendCoins()

        wait(for: [expectation], timeout: 1.0)
    }

    func testViewModelHandlesErrorState() {
        let expectation = XCTestExpectation(description: "Handle error state")

        viewModel.$state
            .dropFirst() // Drop the initial loading state
            .sink { state in
                if case .error(let error) = state {
                    XCTAssertEqual(error, ClientError.generic)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockFetchCryptoPricesUseCase.sendError()

        wait(for: [expectation], timeout: 1.0)
    }

    func testViewModelRetryFetchesCoins() {
        let expectation = XCTestExpectation(description: "Retry fetches coins")

        // Simulate an error first
        mockFetchCryptoPricesUseCase.sendError()

        // Then retry
        viewModel.didTapRetry.send()

        viewModel.$state
            .sink { [mockFetchCryptoPricesUseCase] state in
                if case .data(let coins) = state {
                    XCTAssertEqual(coins.count, mockFetchCryptoPricesUseCase?.stubbedCoins.count)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        mockFetchCryptoPricesUseCase.sendCoins()

        wait(for: [expectation], timeout: 1.0)
    }
}
