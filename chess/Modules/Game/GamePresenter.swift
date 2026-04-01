//
//  GamePresenter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

final class GamePresenter: GamePresenterProtocol, NewGameConfirmationDelegate, PauseMenuDelegate, GameSaving {

    weak var view: GameViewProtocol?

    private let interactor: GameInteractorProtocol
    private let router: GameRouterProtocol

    private var selectedPosition: BoardPosition?
    private var highlightedPositions: [BoardPosition] = []

    init(
        view: GameViewProtocol,
        interactor: GameInteractorProtocol,
        router: GameRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        GameSessionStore.shared.activeGameSaver = self
        renderCurrentState()
    }

    // The presenter translates user taps into either piece selection, movement, or ability targeting.
    func didTapCell(at position: BoardPosition) {
        let state = interactor.currentGameState()

        // A tap on a friendly piece highlights all legal moves for that piece.
        if let tappedPiece = state.piece(at: position),
           tappedPiece.color == state.currentTurn {
            selectedPosition = position
            highlightedPositions = interactor.availableMoves(for: position)
            renderCurrentState()
            return
        }

        if let selectedPosition,
           state.piece(at: selectedPosition) != nil {
            let result = interactor.performMove(from: selectedPosition, to: position)
            self.selectedPosition = nil
            highlightedPositions = []
            handleMoveResult(result)
            return
        }

        // A tap on an empty square can also be used as a target for some special abilities.
        selectedPosition = position
        highlightedPositions = []
        renderCurrentState()
    }

    func didTapPause() {
        interactor.saveGame()
        view?.setPauseState(isPaused: true)
        router.showPauseMenu(delegate: self)
    }

    func didTapResume() {
        view?.setPauseState(isPaused: false)
    }

    func didTapNewGame() {
        router.showNewGameConfirmation(delegate: self)
    }

    func didTapRules() {
        router.openRules()
    }

    func didTapAuthor() {
        router.openAuthor()
    }

    // Undo is available only when the match supports the time machine ability.
    func didTapUndo() {
        let didUndo = interactor.undoLastMove()

        if didUndo {
            selectedPosition = nil
            highlightedPositions = []
            renderCurrentState()
        } else {
            view?.showMessage(AppConstants.Strings.Game.undoUnavailable)
        }
    }

    func didTapUseAbility() {
        let result = interactor.useCurrentPlayerAbility(targetPosition: selectedPosition)

        switch result {
        case let .success(state, message):
            selectedPosition = nil
            highlightedPositions = []
            render(state: state)
            view?.showMessage(message)

        case let .successWithRocket(state, target, message):
            selectedPosition = nil
            highlightedPositions = []
            view?.showRocketAnimation(at: target) { [weak self] in
                self?.render(state: state)
                self?.view?.showMessage(message)
            }

        case let .targetSelectionRequired(message):
            view?.showMessage(message)

        case let .invalidTarget(message),
             let .unavailable(message):
            view?.showMessage(message)
        }
    }

    func didSelectPromotionPiece(_ pieceType: PieceType) {
        let state = interactor.promotePawn(to: pieceType)
        render(state: state)
    }

    func didConfirmNewGame() {
        interactor.clearSavedGame()
        router.returnToStart()
    }

    func didRequestResume() {
        didTapResume()
    }

    func didRequestNewGame() {
        interactor.clearSavedGame()
        router.returnToStart()
    }

    func didRequestRules() {
        router.openRules()
    }

    func didRequestAuthor() {
        router.openAuthor()
    }

    // Convert the result of a move into UI updates such as check, mate, promotion, or errors.
    private func handleMoveResult(_ result: GameMoveResult) {
        switch result {
        case let .success(state):
            render(state: state)

        case .invalidMove:
            renderCurrentState()
            view?.showMessage(AppConstants.Strings.Game.invalidMove)

        case let .promotionRequired(state, pawnColor):
            render(state: state)
            view?.showPromotionOptions(for: pawnColor)

        case let .check(state, checkedKing):
            render(state: state)
            view?.showCheck(for: checkedKing)

        case let .checkmate(state, winner):
            render(state: state)
            view?.showCheckmate(winner: winner)

        case let .stalemate(state):
            render(state: state)
            view?.showStalemate()
        }
    }

    private func renderCurrentState() {
        render(state: interactor.currentGameState())
    }

    // Convert the internal game state into a lightweight view model for the screen.
    private func render(state: GameState) {
        let viewModel = GameViewModelFactory.make(
            from: state,
            selectedPosition: selectedPosition,
            highlightedPositions: highlightedPositions
        )
        view?.showGameState(viewModel)
        view?.updateMoveHistory(viewModel.moveHistory)
    }

    func saveCurrentGame() {
        interactor.saveGame()
    }
}
