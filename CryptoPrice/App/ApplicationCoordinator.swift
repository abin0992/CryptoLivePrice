//
//  ApplicationCoordinator.swift
//  CryptoPrice
//
//  Created by Abin Baby on 11.02.24.
//

import Combine
import SwiftUI
import Swinject
import UIKit

final class ApplicationCoordinator: Coordinator {

    private let window: UIWindow
    private let resolver: Resolver
    private var childCoordinators = [Coordinator]()

    var subscriptions = Set<AnyCancellable>()

    init(
        resolver: Resolver,
        window: UIWindow
    ) {
        self.resolver = resolver
        self.window = window
    }
    
    func start() {
        let homeCoordinator = resolver.resolve(HomeCoordinator.self)!
        homeCoordinator.start()

        childCoordinators = [homeCoordinator]
        window.rootViewController = homeCoordinator.rootViewController

    }
}
