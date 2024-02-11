//
//  CryptoLogoView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI
import Swinject

struct CryptoLogoView: View {
    @EnvironmentObject var resolver: ResolverEnvironment
    let coinId: String
    let coinImage: String

    var body: some View {
        if let viewModel = resolver.container.resolve(
            CryptoLogoViewModel.self,
            arguments: coinId,
            coinImage
        ) {
            CryptoLogoChildView(viewModel: viewModel)
        } else {
            Text("Dependency resolution failed")
        }
    }
}

private  struct CryptoLogoChildView: View {

    @StateObject var viewModel: CryptoLogoViewModel

    init(viewModel: CryptoLogoViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if viewModel.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(Color.theme.secondaryText)
            }
        }
    }
}

#Preview {
    CryptoLogoView(
        coinId: DeveloperPreview.coin.id,
        coinImage: DeveloperPreview.coin.image
    )
}
