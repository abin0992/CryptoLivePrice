//
//  CryptoLogoViewModel.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Combine
import Foundation
import SwiftUI

final class CryptoLogoViewModel: ObservableObject {

    @Published var image: UIImage?
    @Published var isLoading: Bool = false

    private var cancellables = Set<AnyCancellable>()

    private let coinId: String
    private let coinImageUrl: String
    private let fetchCryptoLogoUseCase: FetchCryptoLogoUseCaseProtocol

    init(
        coinId: String,
        coinImageUrl: String,
        fetchCryptoLogoUseCase: FetchCryptoLogoUseCaseProtocol
    ) {
        self.coinId = coinId
        self.coinImageUrl = coinImageUrl
        self.fetchCryptoLogoUseCase = fetchCryptoLogoUseCase
        self.addSubscribers()
        self.isLoading = true
    }

    private func addSubscribers() {
        fetchCryptoLogoUseCase
            .execute(urlString: coinImageUrl, coinId: coinId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnedImage in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
