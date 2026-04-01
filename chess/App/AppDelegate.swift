//
//  AppDelegate.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Apply the saved visual theme before the first screen becomes visible.
        AppTheme.apply()
        return true
    }

    func application(
        _ application: UIApplication,
        // Provide the default scene configuration for the main application window.
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(
            name: AppConstants.App.sceneConfigurationName,
            sessionRole: connectingSceneSession.role
        )
    }
}

