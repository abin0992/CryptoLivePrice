//
//  DependencyManager.swift
//  CryptoPrice
//
//  Created by Abin Baby on 07.02.24.
//

import Foundation
import SwiftUI
import Swinject

// MARK: - DependencyManager

final class DependencyManager {
    static let shared = DependencyManager()
    let container = Container()

    private init() {
        registerDependencies()
    }

    private func registerDependencies() {
        let serviceAssemblies = ServiceAssembly.all
        serviceAssemblies.forEach { $0.assemble(container: container) }

        let moduleAssemblies = ModuleAssembly.all
        moduleAssemblies.forEach { $0.assemble(container: container) }

        let coordinatorAssemblies = CoordinatorAssembly.all
        coordinatorAssemblies.forEach { $0.assemble(container: container) }

        let networkAssemblies = NetworkAssembly.all
        networkAssemblies.forEach { $0.assemble(container: container) }
    }
}
