//
//  String+Extensions.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import Foundation

extension String {

    var removingHTMLOccurances: String {
        self.replacingOccurrences(
            of: "<[^>]+>",
            with: "",
            options: .regularExpression,
            range: nil
        )
    }
}
