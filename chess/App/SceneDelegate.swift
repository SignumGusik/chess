//
//  SceneDelegate.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    // Create the main application window and attach the root navigation flow.
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = RootFactory.makeRootViewController()
        window.makeKeyAndVisible()

        self.window = window
    }

    // Save the current match automatically when the app goes to the background.
    func sceneDidEnterBackground(_ scene: UIScene) {
        GameSessionStore.shared.activeGameSaver?.saveCurrentGame()
    }
}

