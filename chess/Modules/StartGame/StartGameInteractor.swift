//
//  StartGameInteractor.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation
import UIKit

final class StartGameInteractor: StartGameInteractorProtocol {

    private let persistenceService: GamePersistenceServiceProtocol
    private let themeService: ThemeServiceProtocol

    private var selectedAbilities: [PieceColor: Ability] = [:]
    private var abilityChoices: [PieceColor: [Ability]] = [
        .white: AbilityChoiceFactory.makeThreeChoices(),
        .black: AbilityChoiceFactory.makeThreeChoices()
    ]

    init(
        persistenceService: GamePersistenceServiceProtocol,
        themeService: ThemeServiceProtocol
    ) {
        self.persistenceService = persistenceService
        self.themeService = themeService
    }

    func hasSavedGame() -> Bool {
        persistenceService.hasSavedGame()
    }

    func saveSelectedAbility(_ ability: Ability, for color: PieceColor) {
        selectedAbilities[color] = ability
    }

    // Selected abilities are stored temporarily and used to build the initial game state.
    func makeInitialGameState() -> GameState {
        GameStateFactory.makeInitialState(
            whiteAbility: selectedAbilities[.white],
            blackAbility: selectedAbilities[.black],
            whiteChoices: abilityChoices[.white] ?? [],
            blackChoices: abilityChoices[.black] ?? []
        )
    }

    func toggleTheme() -> AppThemeStyle {
        let newTheme: AppThemeStyle = themeService.currentTheme == .light ? .dark : .light
        themeService.apply(theme: newTheme)
        return newTheme
    }

    func choices(for color: PieceColor) -> [Ability] {
        abilityChoices[color] ?? []
    }

    // Generate a fresh random set of abilities for both players before a new match.
    func refreshChoices() {
        abilityChoices[.white] = AbilityChoiceFactory.makeThreeChoices()
        abilityChoices[.black] = AbilityChoiceFactory.makeThreeChoices()
        selectedAbilities.removeAll()
    }
}
