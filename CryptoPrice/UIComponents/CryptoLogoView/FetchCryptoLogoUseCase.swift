//
//  FetchCryptoLogoUseCase.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Combine
import Foundation
import SwiftUI

protocol FetchCryptoLogoUseCaseProtocol {
    func execute(urlString: String, coinId: String) -> AnyPublisher<UIImage?, Never>
}

final class FetchCryptoLogoUseCase: FetchCryptoLogoUseCaseProtocol {

    private let fileManager = LocalFileManager.instance
    private let folderName = "crypto_logos"
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }

    func execute(urlString: String, coinId: String) -> AnyPublisher<UIImage?, Never> {
        if let savedImage = fileManager.getImage(
            imageName: coinId,
            folderName: folderName
        ) {
            Just(savedImage)
                .eraseToAnyPublisher()
        } else {
            downloadCoinLogo(urlString: urlString, coinId: coinId)
        }
    }
}

private extension FetchCryptoLogoUseCase {
    func downloadCoinLogo(urlString: String, coinId: String) -> AnyPublisher<UIImage?, Never> {
        guard let logoUrl = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return httpClient
            .performRequest(
                url: logoUrl,
                method: .get,
                body: nil
            )
            .compactMap { UIImage(data: $0) }
            .handleEvents(
                receiveOutput: { [weak self] logoImage in
                    guard
                        let self,
                        let image = logoImage
                    else {
                        return
                    }
                    self.fileManager.saveImage(
                        image: image,
                        imageName: coinId,
                        folderName: self.folderName
                    )
                }
            )
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
