//
//  StartGamePresenter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

final class StartGamePresenter: StartGamePresenterProtocol, AbilitySelectionDelegate {

    weak var view: StartGameViewProtocol?

    private let interactor: StartGameInteractorProtocol
    private let router: StartGameRouterProtocol

    private var whiteAbility: Ability?
    private var blackAbility: Ability?

    init(
        view: StartGameViewProtocol,
        interactor: StartGameInteractorProtocol,
        router: StartGameRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    // Initialize the start screen with the current save status and empty ability state.
    func viewDidLoad() {
        view?.showTitle(AppConstants.App.startDisplayTitle)
        view?.showContinueGame(isEnabled: interactor.hasSavedGame())
        updateAbilitiesUI()
    }

    // Starting a new game resets previous selections and begins the secret ability selection flow.
    func didTapNewGame() {
        interactor.refreshChoices()
        whiteAbility = nil
        blackAbility = nil
        updateAbilitiesUI()

        router.showPassDeviceAlert(for: .white) { [weak self] in
            guard let self else { return }

            self.router.showAbilitySelection(
                for: .white,
                abilities: self.interactor.choices(for: .white),
                delegate: self
            )
        }
    }

    func didTapContinueGame() {
        router.openSavedGame()
    }

    func didTapRules() {
        router.openRules()
    }

    func didTapAuthor() {
        router.openAuthor()
    }

    // The secret ability selection is performed in two steps: white first, then black.
    func didSelectAbility(_ ability: Ability, for color: PieceColor) {
        interactor.saveSelectedAbility(ability, for: color)

        switch color {
        case .white:
            whiteAbility = ability
            updateAbilitiesUI()

            router.showPassDeviceAlert(for: .black) { [weak self] in
                guard let self else { return }

                self.router.showAbilitySelection(
                    for: .black,
                    abilities: self.interactor.choices(for: .black),
                    delegate: self
                )
            }

        case .black:
            blackAbility = ability
            updateAbilitiesUI()

            let state = interactor.makeInitialGameState()
            router.openGame(with: state)
        }
    }

    func didTapTheme() {
        _ = interactor.toggleTheme()
    }

    // The UI shows only whether an ability was chosen, not the actual secret choice.
    private func updateAbilitiesUI() {
        view?.showSelectedAbilities(
            whiteAbility: whiteAbility?.title,
            blackAbility: blackAbility?.title
        )
    }
}
