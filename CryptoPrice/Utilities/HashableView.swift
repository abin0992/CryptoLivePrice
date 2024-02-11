//
//  HashableView.swift
//  CryptoPrice
//
//  Created by Abin Baby on 09.02.24.
//

import SwiftUI

struct HashableView<Content: View>: View, Identifiable, Hashable {
    let id = UUID()
    let content: Content

    init(_ content: Content) {
        self.content = content
    }

    var body: some View {
        content
    }

    static func == (lhs: HashableView, rhs: HashableView) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
