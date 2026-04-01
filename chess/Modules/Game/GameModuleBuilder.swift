//
//  GameModuleBuilder.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum GameModuleBuilder {
    static func build(initialState: GameState) -> UIViewController {
        let persistenceService = GamePersistenceService()
        let view = GameViewController()
        let interactor = GameInteractor(
            initialState: initialState,
            persistenceService: persistenceService
        )
        let router = GameRouter()
        let presenter = GamePresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }

    static func buildFromSavedGame() -> UIViewController {
        let persistenceService = GamePersistenceService()
        let savedState = persistenceService.load()
            ?? GameStateFactory.makeInitialState(
                whiteAbility: nil,
                blackAbility: nil
            )

        return build(initialState: savedState)
    }
}
