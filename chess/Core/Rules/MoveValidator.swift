//
//  MoveValidator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum MoveValidator {

    // A move is valid only if it belongs to the list of legal moves generated for the piece.
    static func isMoveAllowed(
        for piece: Piece,
        to target: BoardPosition,
        in state: GameState
    ) -> Bool {
        let moves = LegalMoveGenerator.generateLegalMoves(for: piece, in: state)
        return moves.contains(target)
    }
}
