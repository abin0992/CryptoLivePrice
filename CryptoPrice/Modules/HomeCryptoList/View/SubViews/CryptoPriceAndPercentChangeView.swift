//
//  CryptoPriceAndPercentChangeView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import SwiftUI

struct CryptoPriceAndPercentChangeView: View {

    let coin: CoinRowViewModel

    var body: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice)
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H)
                .foregroundColor(
                    (coin.priceChangePercentage24HValue ?? 0 >= 0) ?
                    Color.theme.ctGreen :
                    Color.theme.ctRed
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

#Preview {
    CryptoPriceAndPercentChangeView(
        coin: CoinViewModelFactory.createViewModel(from: DeveloperPreview.coin)
    )
}
