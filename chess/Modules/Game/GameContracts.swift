//
//  GameContracts.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

protocol GameViewProtocol: AnyObject {
    func showGameState(_ state: GameStateViewModel)
    func showCheck(for color: PieceColor)
    func showCheckmate(winner: PieceColor)
    func showStalemate()
    func showPromotionOptions(for color: PieceColor)
    func showMessage(_ text: String)
    func updateMoveHistory(_ moves: [String])
    func setPauseState(isPaused: Bool)
    func showRocketAnimation(at position: BoardPosition, completion: @escaping () -> Void)
}

protocol GamePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapCell(at position: BoardPosition)
    func didTapPause()
    func didTapResume()
    func didTapNewGame()
    func didTapRules()
    func didTapAuthor()
    func didTapUndo()
    func didTapUseAbility()
    func didSelectPromotionPiece(_ pieceType: PieceType)
}

protocol GameInteractorProtocol: AnyObject {
    func loadGame() -> GameState
    func saveGame()
    func createNewGame()
    func availableMoves(for position: BoardPosition) -> [BoardPosition]
    func performMove(from: BoardPosition, to: BoardPosition) -> GameMoveResult
    func currentGameState() -> GameState
    func undoLastMove() -> Bool
    func useCurrentPlayerAbility(targetPosition: BoardPosition?) -> AbilityUseResult
    func promotePawn(to pieceType: PieceType) -> GameState
    func clearSavedGame()
}

protocol GameRouterProtocol: AnyObject {
    func openRules()
    func openAuthor()
    func returnToStart()
    func showNewGameConfirmation(delegate: NewGameConfirmationDelegate)
    func showPauseMenu(delegate: PauseMenuDelegate)
}

protocol NewGameConfirmationDelegate: AnyObject {
    func didConfirmNewGame()
}

protocol PauseMenuDelegate: AnyObject {
    func didRequestResume()
    func didRequestNewGame()
    func didRequestRules()
    func didRequestAuthor()
}

protocol GamePersistenceServiceProtocol: AnyObject {
    func save(_ state: GameState)
    func load() -> GameState?
    func hasSavedGame() -> Bool
    func clearSavedGame()
}
