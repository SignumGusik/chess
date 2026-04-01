//
//  GameInteractor.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

// The interactor contains the main game rules and does not depend on UIKit.
final class GameInteractor: GameInteractorProtocol {

    private var gameState: GameState
    private let persistenceService: GamePersistenceServiceProtocol

    init(
        initialState: GameState,
        persistenceService: GamePersistenceServiceProtocol
    ) {
        self.gameState = initialState
        self.persistenceService = persistenceService
    }

    func loadGame() -> GameState {
        gameState.isPaused = false
        return gameState
    }

    func saveGame() {
        gameState.isPaused = true
        persistenceService.save(gameState)
    }

    func createNewGame() {
    }

    func availableMoves(for position: BoardPosition) -> [BoardPosition] {
        guard let piece = gameState.piece(at: position) else {
            return []
        }

        guard piece.color == gameState.currentTurn else {
            return []
        }

        return LegalMoveGenerator.generateLegalMoves(for: piece, in: gameState)
    }

    // Invalid moves are rejected before changing the game state.
    func performMove(from: BoardPosition, to: BoardPosition) -> GameMoveResult {
        switch gameState.result {
        case .checkmate, .stalemate:
            return .invalidMove
        case .ongoing, .check:
            break
        }

        guard let piece = gameState.piece(at: from) else {
            return .invalidMove
        }

        guard piece.color == gameState.currentTurn else {
            return .invalidMove
        }

        let legalMoves = LegalMoveGenerator.generateLegalMoves(for: piece, in: gameState)
        guard legalMoves.contains(to) else {
            return .invalidMove
        }

        let updatedState = MoveApplier.applyMove(
            piece: piece,
            from: from,
            to: to,
            in: gameState
        )

        gameState = updatedState

        if updatedState.pendingPromotionPawnID != nil {
            return .promotionRequired(updatedState, pawnColor: piece.color)
        }

        switch updatedState.result {
        case let .checkmate(winner):
            return .checkmate(updatedState, winner: winner)
        case .stalemate:
            return .stalemate(updatedState)
        case let .check(checkedKing):
            return .check(updatedState, checkedKing: checkedKing)
        case .ongoing:
            return .success(updatedState)
        }
    }

    func currentGameState() -> GameState {
        gameState
    }

    // Undo restores the latest saved snapshot, including board state, turn, and move counters.
    func undoLastMove() -> Bool {
        let canUseTimeMachine = gameState.abilities.contains { $0.selectedAbility == .timeMachine }
        guard canUseTimeMachine else {
            return false
        }

        guard let lastSnapshot = gameState.snapshots.last else {
            return false
        }

        gameState.pieces = lastSnapshot.pieces
        gameState.currentTurn = lastSnapshot.currentTurn
        gameState.moves = lastSnapshot.moves
        gameState.moveCount = lastSnapshot.moveCount
        gameState.result = lastSnapshot.result
        gameState.abilities = lastSnapshot.abilities
        gameState.snapshots.removeLast()
        gameState.pendingPromotionPawnID = nil
        gameState.enPassantTarget = lastSnapshot.enPassantTarget
        gameState.checkedKingColor = lastSnapshot.checkedKingColor
        gameState.fullMoveNumber = lastSnapshot.fullMoveNumber

        return true
    }

    func useCurrentPlayerAbility(targetPosition: BoardPosition?) -> AbilityUseResult {
        let result = AbilityExecutor.useCurrentPlayerAbility(
            in: gameState,
            targetPosition: targetPosition
        )

        switch result {
        case let .success(updatedState, message):
            gameState = updatedState
            return .success(updatedState, message: message)

        case let .successWithRocket(updatedState, target, message):
            gameState = updatedState
            return .successWithRocket(updatedState, target: target, message: message)

        case let .targetSelectionRequired(message):
            return .targetSelectionRequired(message: message)

        case let .invalidTarget(message):
            return .invalidTarget(message: message)

        case let .unavailable(message):
            return .unavailable(message: message)
        }
    }

    // Promotion replaces the pawn in place and updates the last move notation accordingly.
    func promotePawn(to pieceType: PieceType) -> GameState {
        guard let pawnID = gameState.pendingPromotionPawnID,
              let pawnIndex = gameState.pieces.firstIndex(where: { $0.id == pawnID }) else {
            return gameState
        }

        guard [.queen, .rook, .bishop, .knight].contains(pieceType) else {
            return gameState
        }

        let oldPawn = gameState.pieces[pawnIndex]

        let promotedPiece = Piece(
            id: oldPawn.id,
            type: pieceType,
            color: oldPawn.color,
            position: oldPawn.position,
            hasMoved: true,
            isCaptured: false
        )

        gameState.pieces[pawnIndex] = promotedPiece
        gameState.pendingPromotionPawnID = nil

        let opponentColor = oldPawn.color.opposite
        let isCheck = CheckDetector.isKingInCheck(color: opponentColor, in: gameState)
        let isCheckmate = CheckmateDetector.isCheckmate(for: opponentColor, in: gameState)
        let isStalemate = StalemateDetector.isStalemate(for: opponentColor, in: gameState)

        if let lastMoveIndex = gameState.moves.indices.last {
            let lastMove = gameState.moves[lastMoveIndex]
            let capturedPiece: Piece? = {
                guard let capturedID = lastMove.capturedPieceID else {
                    return nil
                }
                return gameState.pieces.first { $0.id == capturedID }
            }()

            let updatedNotation = ChessNotationFormatter.notation(
                for: oldPawn,
                from: lastMove.from,
                to: lastMove.to,
                capturedPiece: capturedPiece,
                promotion: pieceType,
                isCheck: isCheck,
                isCheckmate: isCheckmate
            )

            gameState.moves[lastMoveIndex] = ChessMove(
                id: lastMove.id,
                from: lastMove.from,
                to: lastMove.to,
                movedPieceID: lastMove.movedPieceID,
                movedPieceType: lastMove.movedPieceType,
                movedPieceColor: lastMove.movedPieceColor,
                capturedPieceID: lastMove.capturedPieceID,
                capturedPieceType: lastMove.capturedPieceType,
                promotionPieceType: pieceType,
                isCheck: isCheck,
                isCheckmate: isCheckmate,
                notation: updatedNotation
            )
        }

        gameState.checkedKingColor = isCheck ? opponentColor : nil

        if isCheckmate {
            gameState.result = .checkmate(winner: oldPawn.color)
        } else if isStalemate {
            gameState.result = .stalemate
        } else if isCheck {
            gameState.result = .check(checkedKing: opponentColor)
        } else {
            gameState.result = .ongoing
        }

        return gameState
    }
    func clearSavedGame() {
        persistenceService.clearSavedGame()
    }
}
