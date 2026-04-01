//
//  LegalMoveGenerator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum LegalMoveGenerator {

    // Legal moves are filtered from pseudo-legal moves by removing moves that leave the king in check.
    static func generateLegalMoves(for piece: Piece, in state: GameState) -> [BoardPosition] {
        let pseudoLegalMoves = MoveGenerator.generateMoves(for: piece, in: state)

        return pseudoLegalMoves.filter { target in
            let simulatedState = MoveSimulator.simulateMove(
                piece: piece,
                from: piece.position,
                to: target,
                in: state
            )

            return !CheckDetector.isKingInCheck(color: piece.color, in: simulatedState)
        }
    }

    // The existence of at least one legal move is used in checkmate and stalemate detection.
    static func hasAnyLegalMove(for color: PieceColor, in state: GameState) -> Bool {
        let pieces = state.activePieces.filter { $0.color == color }

        for piece in pieces {
            let legalMoves = generateLegalMoves(for: piece, in: state)
            if !legalMoves.isEmpty {
                return true
            }
        }

        return false
    }
}
