//
//  StartGameModuleBuilder.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum StartGameModuleBuilder {
    static func build() -> UIViewController {
        let persistenceService = GamePersistenceService()
        let settingsService = SettingsService()
        let themeService = ThemeService(settingsService: settingsService)

        let view = StartGameViewController()
        let interactor = StartGameInteractor(
            persistenceService: persistenceService,
            themeService: themeService
        )
        let router = StartGameRouter()
        let presenter = StartGamePresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }
}
