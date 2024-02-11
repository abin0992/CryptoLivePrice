//
//  ResolverEnvironment.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation
import Swinject

final class ResolverEnvironment: ObservableObject {
    let container: Container

    init(container: Container) {
        self.container = container
    }

    func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }
}
