//
//  CoinRowView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI

struct CoinRowView: View {

    let coin: CoinRowViewModel

    var body: some View {
        HStack(spacing: 0) {
            CryptoLogoAndSymbolView(coin: coin)
            Spacer()
            CryptoPriceAndPercentChangeView(coin: coin)
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
}
