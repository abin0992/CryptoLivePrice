//
//  CoordinatorAssembly.swift
//  CryptoPrice
//
//  Created by Abin Baby on 08.02.24.
//

import Foundation
import Swinject

final class CoordinatorAssembly {
    static let all: [Assembly] = [
        AppCoordinatorAssembly(),
        HomeCoordinatorAssembly()
    ]
}

final class AppCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
//        container.register(AppCoordinator.self) { resolver, path in
//            AppCoordinator(
//                resolver: resolver,
//                path: path
//            )
//        }

        container.register(ApplicationCoordinator.self) { resolver, window in
            ApplicationCoordinator(
                resolver: resolver,
                window: window
            )
        }
    }
}

final class HomeCoordinatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(HomeCoordinator.self) { resolver in
            HomeCoordinator(
                resolver: resolver
            )
        }
    }
}
