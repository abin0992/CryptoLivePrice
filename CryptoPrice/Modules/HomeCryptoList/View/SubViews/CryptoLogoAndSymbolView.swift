//
//  CryptoLogoAndSymbolView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI

struct CryptoLogoAndSymbolView: View {

    let coin: CoinRowViewModel

    var body: some View {
        HStack(spacing: 0) {
            Text(coin.rank)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CryptoLogoView(
                coinId: coin.id,
                coinImage: coin.image
            )
                .frame(width: 30, height: 30)
            Text(coin.symbol)
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
}

#Preview {
    CryptoLogoAndSymbolView(
        coin: CoinViewModelFactory.createViewModel(from: DeveloperPreview.coin)
    )
}
