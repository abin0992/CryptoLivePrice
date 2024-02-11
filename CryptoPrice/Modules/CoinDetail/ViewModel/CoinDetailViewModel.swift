//
//  CoinDetailViewModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
import Foundation

final class CoinDetailViewModel: ObservableObject {

    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?

    @Published var coin: CoinRowViewModel

    private var cancellables = Set<AnyCancellable>()
    private let mapDataToStatisticsUseCase = MapDataToStatisticsUseCase()

    private lazy var fetchCryptoDetailResult = makeCryptoDetailFetchResult()
        .share()
    private lazy var statisticsResult = makeStatisticsResult()

    let didTapRetry = PassthroughSubject<Void, Never>()

    private let fetchCrypoDetailUseCase: FetchCrypoDetailUseCaseProtocol

    init(
        fetchCrypoDetailUseCase: FetchCrypoDetailUseCaseProtocol,
        coin: CoinRowViewModel
    ) {
        self.fetchCrypoDetailUseCase = fetchCrypoDetailUseCase
        self.coin = coin
        setUpBindings()
    }

}

private extension CoinDetailViewModel {

    func setUpBindings() {

        statisticsResult
            .map { $0.overview }
            .receive(on: RunLoop.main)
            .assign(to: &$overviewStatistics)

        statisticsResult
            .map { $0.additional }
            .receive(on: RunLoop.main)
            .assign(to: &$additionalStatistics)

        fetchCryptoDetailResult
            .compactMap { $0.value }
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails.readableDescription
                self?.websiteURL = returnedCoinDetails.links?.homepage?.first
                self?.redditURL = returnedCoinDetails.links?.subredditURL
            }
            .store(in: &cancellables)
    }
}

private extension CoinDetailViewModel {

    func makeCryptoDetailFetchResult() -> AnyPublisher<DomainResult<CoinDetailModel>, Never> {
        fetchCrypoDetailUseCase.execute(coinId: coin.id)
    }

    func makeStatisticsResult() -> AnyPublisher<(overview: [StatisticModel], additional: [StatisticModel]), Never> {
        fetchCryptoDetailResult
            .compactMap { $0.value }
            .combineLatest($coin)
            .flatMap { [mapDataToStatisticsUseCase] coinDetail, coin -> AnyPublisher<(overview: [StatisticModel], additional: [StatisticModel]), Never> in
                mapDataToStatisticsUseCase.execute(
                    coinDetailModel: coinDetail,
                    coinModel: coin
                )
            }
            .eraseToAnyPublisher()
    }
}
