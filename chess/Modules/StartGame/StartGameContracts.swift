//
//  StartGameContracts.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

protocol StartGameViewProtocol: AnyObject {
    func showTitle(_ text: String)
    func showContinueGame(isEnabled: Bool)
    func showSelectedAbilities(
        whiteAbility: String?,
        blackAbility: String?
    )
}

protocol StartGamePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapNewGame()
    func didTapContinueGame()
    func didTapRules()
    func didTapAuthor()
    func didSelectAbility(_ ability: Ability, for color: PieceColor)
    func didTapTheme()
}

protocol StartGameInteractorProtocol: AnyObject {
    func hasSavedGame() -> Bool
    func saveSelectedAbility(_ ability: Ability, for color: PieceColor)
    func makeInitialGameState() -> GameState
    func toggleTheme() -> AppThemeStyle
    func choices(for color: PieceColor) -> [Ability]
    func refreshChoices()
}

protocol StartGameRouterProtocol: AnyObject {
    func openGame(with state: GameState)
    func openSavedGame()
    func openRules()
    func openAuthor()
    func showAbilitySelection(
        for color: PieceColor,
        abilities: [Ability],
        delegate: AbilitySelectionDelegate
    )
    func showPassDeviceAlert(
        for color: PieceColor,
        completion: @escaping () -> Void
    )
}

protocol AbilitySelectionDelegate: AnyObject {
    func didSelectAbility(_ ability: Ability, for color: PieceColor)
}
