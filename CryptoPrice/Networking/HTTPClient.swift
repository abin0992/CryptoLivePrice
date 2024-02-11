//
//  HTTPClient.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Combine
import Foundation

protocol HTTPClientProtocol {
    func performRequest(url: URL, method: HTTPMethod, body: Data?) -> AnyPublisher<Data, Error>
}

final class HTTPClient: HTTPClientProtocol {

    private let logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    private let session: URLSession

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func performRequest(
        url: URL,
        method: HTTPMethod = .get,
        body: Data? = nil
    ) -> AnyPublisher<Data, Error> {

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body

        logger.log(request: request)

        return session.dataTaskPublisher(for: request)
            .tryMap { [logger] result -> Data in

                guard
                    let httpResponse = result.response as? HTTPURLResponse,
                    200..<300 ~= httpResponse.statusCode
                else {
                    throw ClientError.badURLResponse(url: url)
                }

                logger.log(responseData: result.data, response: httpResponse)

                #if DEBUG
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(
                            with: result.data,
                            options: []
                        )
                        let prettyJsonData = try JSONSerialization.data(
                            withJSONObject: jsonObject,
                            options: [.prettyPrinted]
                        )
                        if let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) {
                            DLog("Response JSON for URL \(url.absoluteString): \(prettyPrintedJson)")
                        }
                    } catch {
                        if let jsonStr = String(data: result.data, encoding: .utf8) {
                            DLog("Response JSON for URL \(url.absoluteString): \(jsonStr)")
                        }
                    }
                #endif
                return result.data
            }
            .retry(3)
            .eraseToAnyPublisher()
    }
}
