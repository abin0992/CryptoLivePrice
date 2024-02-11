//
//  MapDataToStatisticsUseCase.swift
//  CryptoPrice
//
//  Created by Abin Baby on 11.02.24.
//

import Combine
import Foundation

final class MapDataToStatisticsUseCase {

    func execute(
        coinDetailModel: CoinDetailModel,
        coinModel: CoinRowViewModel
    ) -> AnyPublisher<(overview: [StatisticModel], additional: [StatisticModel]), Never> {
        let overviewPublisher = Just(createOverviewArray(coinModel: coinModel))
            .eraseToAnyPublisher()

        let additionalPublisher = Just(createAdditionalArray(coinDetailModel: coinDetailModel, coinModel: coinModel))
            .eraseToAnyPublisher()

        return Publishers.CombineLatest(
                overviewPublisher,
                additionalPublisher
            )
            .map { (overview: $0, additional: $1) }
            .eraseToAnyPublisher()
    }
}

private extension MapDataToStatisticsUseCase {

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
