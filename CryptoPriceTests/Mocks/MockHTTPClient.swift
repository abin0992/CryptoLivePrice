//
//  MockHTTPClient.swift
//  CryptoPriceTests
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
@testable import CryptoPrice
import Foundation

final class MockHTTPClient: HTTPClientProtocol {
    var responseData: Data?
    var error: Error?

    func performRequest(url: URL, method: HTTPMethod, body: Data?) -> AnyPublisher<Data, Error> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        if let responseData = responseData {
            return Just(responseData)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        return Fail(error: ClientError.badURLResponse(url: url)).eraseToAnyPublisher()
    }
}
