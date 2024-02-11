//
//  CoinDetailViewModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
import Foundation

class CoinDetailViewModel: ObservableObject {

    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    @Published var coinDescription: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?

    @Published var coin: CoinRowViewModel

    private var cancellables = Set<AnyCancellable>()
    private lazy var fetchCryptoDetailResult = makeCryptoDetailFetchResult()
        .share()

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
        fetchCryptoDetailResult
            .compactMap { $0.value }
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &cancellables)

        fetchCryptoDetailResult
            .compactMap { $0.value }
            .sink { [weak self] returnedCoinDetails in
                self?.coinDescription = returnedCoinDetails.readableDescription
                self?.websiteURL = returnedCoinDetails.links?.homepage?.first
                self?.redditURL = returnedCoinDetails.links?.subredditURL
            }
            .store(in: &cancellables)
    }

    func makeCryptoDetailFetchResult() -> AnyPublisher<DomainResult<CoinDetailModel>, Never> {
        fetchCrypoDetailUseCase.execute(coinId: coin.id)
    }
}

private extension CoinDetailViewModel {

    func mapDataToStatistics(
        coinDetailModel: CoinDetailModel,
        coinModel: CoinRowViewModel
    ) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overviewArray = createOverviewArray(coinModel: coinModel)
        let additionalArray = createAdditionalArray(
            coinDetailModel: coinDetailModel,
            coinModel: coinModel
        )
        return (overviewArray, additionalArray)
    }

    func createOverviewArray(coinModel: CoinRowViewModel) -> [StatisticModel] {
        let price = coinModel.currentPrice
        let pricePercentChange = coinModel.priceChangePercentage24HValue
        let priceStat = StatisticModel(
            title: "Current Price",
            value: price,
            percentageChange: pricePercentChange
        )

        let marketCap = "$" + coinModel.marketCap
        let marketCapPercentChange = coinModel.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(
            title: "Market Capitalization",
            value: marketCap,
            percentageChange: marketCapPercentChange
        )

        let rank = "\(coinModel.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + coinModel.totalVolume
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        let overviewArray: [StatisticModel] = [
            priceStat,
            marketCapStat,
            rankStat,
            volumeStat
        ]
        return overviewArray
    }

    func createAdditionalArray(
        coinDetailModel: CoinDetailModel?,
        coinModel: CoinRowViewModel
    ) -> [StatisticModel] {

        let highStat = StatisticModel(title: "24h High", value: coinModel.high24H)

        let lowStat = StatisticModel(title: "24h Low", value: coinModel.low24H)

        let priceChangeStat = StatisticModel(
            title: "24h Price Change",
            value: coinModel.priceChange24H,
            percentageChange: coinModel.priceChangePercentage24HValue
        )

        let marketCapChangeStat = StatisticModel(
            title: "24h Market Cap Change",
            value: "$" + coinModel.marketCapChange24H,
            percentageChange: coinModel.marketCapChangePercentage24H
        )

        let blockTime = coinDetailModel?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetailModel?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        let additionalArray: [StatisticModel] = [
            highStat,
            lowStat,
            priceChangeStat,
            marketCapChangeStat,
            blockStat,
            hashingStat
        ]
        return additionalArray
    }
}
