//
//  HomeCryptoListView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI

struct HomeCryptoListView: View {

    @ObservedObject var viewModel: HomeCryptoListViewModel

    init(viewModel: HomeCryptoListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            switch viewModel.state {
            case .loading:
                // TODO: Use better loading view with animation
                Text("Loading...")
            case .data(let coins):
                dataContentView(coins: coins)
            case .error(let clientError):
                ErrorPopupView(
                    title: "Error Occurred",
                    subtitle: clientError.localizedDescription,
                    retryAction: {
                        viewModel.didTapRetry.send(())
                    }
                )
            default:
                VStack {}
            }
        }
        .navigationBarTitle("Live crypto prices")
        .navigationBarBackButtonHidden(true)
    }
}

private extension HomeCryptoListView {
    func dataContentView(coins: [CoinRowViewModel]) -> some View {
        List {
            ForEach(coins) { coin in
                CoinRowView(coin: coin)
                    .listRowInsets(
                        .init(
                            top: 10,
                            leading: 0,
                            bottom: 10,
                            trailing: 10)
                    )
                    .onTapGesture {
                        if Features.isCryptoDetailScreenEnabled {
                            viewModel.output.send(coin)
                        }
                    }
                    .listRowBackground(Color.theme.background)
            }
        }
        .scrollContentBackground(.hidden)
        .refreshable {
            viewModel.refreshPrices.send(())
        }
    }
}

#Preview {
    HomeCryptoListView(
        viewModel: DeveloperPreview.instance.previewHomeViewModel
    )
}
