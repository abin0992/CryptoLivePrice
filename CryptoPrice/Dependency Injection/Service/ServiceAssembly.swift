//
//  ServiceAssembly.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Foundation
import Swinject

final class ServiceAssembly {

    static let all: [Assembly] = [
        CryptoServiceAssembly()
    ]

}

final class CryptoServiceAssembly: Assembly {

    func assemble(container: Container) {
        container.register(CryptoFetchable.self) { resolver in
            CryptoService(
                httpClient: resolver.resolve(HTTPClientProtocol.self)!
            )
        }
    }

}
