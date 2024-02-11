//
//  HomeCoordinator.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import Combine
import SwiftUI
import Swinject

final class HomeCoordinator: Coordinator {

    var rootViewController: UINavigationController = UINavigationController()
    private var cancellables = Set<AnyCancellable>()

    private let resolver: Resolver
    private let resolverEnvironment: ResolverEnvironment

    init(
        resolver: Resolver,
        resolverEnvironment: ResolverEnvironment
    ) {
        self.resolver = resolver
        self.resolverEnvironment = resolverEnvironment
    }

    func start() {
        displayHomeView()
    }

}

private extension HomeCoordinator {

    func displayHomeView() {

        guard let homeViewModel = resolver.resolve(HomeCryptoListViewModel.self) else {
            return
        }

        homeViewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coin in
                self?.navigateToDetailScreen(coin: coin)
            }
            .store(in: &cancellables)

        let homeView = HomeCryptoListView(viewModel: homeViewModel)
            .environmentObject(resolverEnvironment)
        let homeViewController = UIHostingController(rootView: homeView)

        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.setViewControllers([homeViewController], animated: false)
    }

    func navigateToDetailScreen(coin: CoinRowViewModel) {

        guard let coinDetailViewModel = resolver.resolve(
            CoinDetailViewModel.self,
            argument: coin
        ) else {
            return
        }

        let coinDetailView = CoinDetailView(viewModel: coinDetailViewModel)
            .environmentObject(resolverEnvironment)
        let detailViewController = UIHostingController(rootView: coinDetailView)

        rootViewController.pushViewController(detailViewController, animated: true)

    }
}
