//
//  RootFactory.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum RootFactory {
    
    // The app always starts from the start game module wrapped in a navigation controller.
    static func makeRootViewController() -> UIViewController {
        let startModule = StartGameModuleBuilder.build()
        let navigationController = UINavigationController(rootViewController: startModule)
        return navigationController
    }
}
