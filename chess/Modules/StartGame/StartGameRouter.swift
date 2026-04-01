//
//  StartGameRouter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class StartGameRouter: StartGameRouterProtocol {

    weak var viewController: UIViewController?

    func openGame(with state: GameState) {
        let gameModule = GameModuleBuilder.build(initialState: state)
        viewController?.navigationController?.pushViewController(gameModule, animated: true)
    }

    func openSavedGame() {
        let gameModule = GameModuleBuilder.buildFromSavedGame()
        viewController?.navigationController?.pushViewController(gameModule, animated: true)
    }

    func openRules() {
        let module = RulesModuleBuilder.build()
        viewController?.navigationController?.pushViewController(module, animated: true)
    }

    func openAuthor() {
        let module = AuthorModuleBuilder.build()
        viewController?.navigationController?.pushViewController(module, animated: true)
    }

    // Present the list of random ability options for the current player.
    func showAbilitySelection(
        for color: PieceColor,
        abilities: [Ability],
        delegate: AbilitySelectionDelegate
    ) {
        guard let viewController else {
            return
        }
        let title = color == .white
                    ? AppConstants.Strings.Start.whiteAbilitySelectionTitle
                    : AppConstants.Strings.Start.blackAbilitySelectionTitle

        let alert = UIAlertController(
            title: title,
            message: AppConstants.Strings.Start.abilitySelectionMessage,
            preferredStyle: .actionSheet
        )

        for ability in abilities {
            alert.addAction(
                UIAlertAction(title: ability.title, style: .default) { _ in
                    delegate.didSelectAbility(ability, for: color)
                }
            )
        }

        alert.addAction(UIAlertAction(title: AppConstants.Strings.Common.cancel, style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(
                x: viewController.view.bounds.midX,
                y: viewController.view.bounds.midY,
                width: 1,
                height: 1
            )
        }

        viewController.present(alert, animated: true)
    }

    // This alert hides the previous player's choice and asks to pass the device safely.
    func showPassDeviceAlert(
        for color: PieceColor,
        completion: @escaping () -> Void
    ) {
        guard let viewController else {
            return
        }

        
        let message = color == .white
                    ? AppConstants.Strings.Start.passDeviceToWhite
                    : AppConstants.Strings.Start.passDeviceToBlack

        let alert = UIAlertController(
            title: AppConstants.Strings.Start.secretAbilitySelectionTitle,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: AppConstants.Strings.Start.continueAction, style: .default) { _ in
            completion()
        })

        viewController.present(alert, animated: true)
    }
}
