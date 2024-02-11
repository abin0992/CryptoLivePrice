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

    private lazy var container = DependencyManager.shared.container
    private lazy var resolverEnvironment = ResolverEnvironment(container: container)

    private let resolver: Resolver
    private var cancellables = Set<AnyCancellable>()

    init(resolver: Resolver) {
        self.resolver = resolver
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
        rootViewController.setViewControllers([homeViewController], animated: false)
    }

    func navigateToDetailScreen(coin: CoinRowViewModel) {
        guard let coinDetailViewModel = resolver.resolve(
            CoinDetailViewModel.self,
            argument: coin
        ) else {
            return
        }

        
//        ResolverEnvironment(
//            container: DependencyManager.shared.container
//        )
        
        let coinDetailView = CoinDetailView(viewModel: coinDetailViewModel)
            .environmentObject(resolverEnvironment)
        

        let detailViewController = UIHostingController(
            rootView: coinDetailView
        )
        rootViewController.pushViewController(detailViewController, animated: true)
        
    }
}
