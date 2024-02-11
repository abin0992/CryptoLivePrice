//
//  APIEndpoint.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation

// MARK: - HTTPMethod

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

// MARK: - URLConfig

protocol URLConfig {
    var url: URL { get }
}

// MARK: - PEEndPoint

struct Endpoint: URLConfig {

    let path: String
    var queryItems: [URLQueryItem] = []
    var url: URL {
        var components: URLComponents = URLComponents()
        components.scheme = "https"
        components.host = AppConfiguration.apiBaseURL
        components.path = path
        components.queryItems = queryItems

        guard let url = components.url else {
            preconditionFailure(
                "Invalid URL components: \(components)"
            )
        }
        return url
    }
}
