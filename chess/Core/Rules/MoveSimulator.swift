//
//  MoveSimulator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum MoveSimulator {

    // Simulated moves are used to test king safety without permanently changing the real game state.
    static func simulateMove(
        piece: Piece,
        from: BoardPosition,
        to: BoardPosition,
        in state: GameState
    ) -> GameState {
        var simulatedState = state

        var capturedPiece = simulatedState.piece(at: to)

        if piece.type == .pawn,
           capturedPiece == nil,
           from.column != to.column,
           let enPassantTarget = simulatedState.enPassantTarget,
           enPassantTarget == to {
            let capturedPawnPosition = BoardPosition(row: from.row, column: to.column)
            capturedPiece = simulatedState.piece(at: capturedPawnPosition)
        }

        if let capturedPiece {
            simulatedState.capturePiece(withID: capturedPiece.id)
        }

        simulatedState.movePiece(withID: piece.id, to: to)
        simulatedState.enPassantTarget = nil
        simulatedState.pendingPromotionPawnID = nil
        simulatedState.checkedKingColor = nil

        return simulatedState
    }
}
