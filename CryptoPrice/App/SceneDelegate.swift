//
//  SceneDelegate.swift
//  CryptoPrice
//
//  Created by Abin Baby on 11.02.24.
//

import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var applicationCoordintor: ApplicationCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let applicationCoordintor = ApplicationCoordinator(
                resolver: DependencyManager.shared.container,
                window: window
            )
            applicationCoordintor.start()

            self.applicationCoordintor = applicationCoordintor
            window.makeKeyAndVisible()
        }
    }
}

