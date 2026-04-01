//
//  GameRouter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class GameRouter: GameRouterProtocol {

    weak var viewController: UIViewController?

    func openRules() {
        let module = RulesModuleBuilder.build()
        viewController?.navigationController?.pushViewController(module, animated: true)
    }

    func openAuthor() {
        let module = AuthorModuleBuilder.build()
        viewController?.navigationController?.pushViewController(module, animated: true)
    }

    func returnToStart() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }

    func showNewGameConfirmation(delegate: NewGameConfirmationDelegate) {
        guard let viewController else {
            return
        }

        let alert = UIAlertController(
            title: "Новая игра",
            message: "Начать новую партию?",
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "Да", style: .destructive) { _ in
                delegate.didConfirmNewGame()
            }
        )
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))

        viewController.present(alert, animated: true)
    }

    func showPauseMenu(delegate: PauseMenuDelegate) {
        guard let viewController else {
            return
        }

        let alert = UIAlertController(
            title: "Пауза",
            message: "Игра сохранена. Выберите действие.",
            preferredStyle: .actionSheet
        )

        alert.addAction(
            UIAlertAction(title: "Продолжить", style: .default) { _ in
                delegate.didRequestResume()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Новая игра", style: .destructive) { _ in
                delegate.didRequestNewGame()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Правила", style: .default) { _ in
                delegate.didRequestRules()
            }
        )
        alert.addAction(
            UIAlertAction(title: "Об авторе", style: .default) { _ in
                delegate.didRequestAuthor()
            }
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))

        viewController.present(alert, animated: true)
    }
}
