//
//  ResolverEnvironment.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation
import Swinject

final class ResolverEnvironment: ObservableObject {
    lazy var container = DependencyManager.shared.container

    private func resolve<Service>(_ serviceType: Service.Type) -> Service? {
        container.resolve(serviceType)
    }
}
