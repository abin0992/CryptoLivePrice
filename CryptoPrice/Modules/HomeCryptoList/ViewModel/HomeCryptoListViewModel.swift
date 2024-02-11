//
//  HomeCryptoListViewModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Combine
import Foundation

final class HomeCryptoListViewModel: ObservableObject {

    var output = PassthroughSubject<CoinRowViewModel, Never>()

    @Published var state = StateModel<[CoinRowViewModel]>.State.loading

    let didTapRetry = PassthroughSubject<Void, Never>()
    let refreshPrices = PassthroughSubject<Void, Never>()

    private lazy var fetchCryptoPriceListResult = makeInitialPriceFetchResult()
        .share()

    private let fetchCryptoPricesUseCase: FetchCryptoPricesUseCaseProtocol

    init(fetchCryptoPricesUseCase: FetchCryptoPricesUseCaseProtocol) {
        self.fetchCryptoPricesUseCase = fetchCryptoPricesUseCase
        setUpBindings()
    }

}

private extension HomeCryptoListViewModel {

    func setUpBindings() {
        bindState()
    }

    func bindState() {
        fetchCryptoPriceListResult
            .receive(on: DispatchQueue.main)
            .map { result -> StateModel<[CoinRowViewModel]>.State in
                switch result {
                case .error:
                    return .error(ClientError.generic)
                case .success(let cryptoPrices):
                    return .data(cryptoPrices)
                }
            }
            .assign(to: &$state)
    }

    func makeInitialPriceFetchResult() -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never> {
        Publishers.Merge3(
            Just<Void>(()),
            didTapRetry,
            refreshPrices
        )
        .flatMap { [fetchCryptoPricesUseCase] _ -> AnyPublisher<DomainResult<[CoinRowViewModel]>, Never> in
            fetchCryptoPricesUseCase.execute(page: "1")
        }
        .eraseToAnyPublisher()
    }
}
