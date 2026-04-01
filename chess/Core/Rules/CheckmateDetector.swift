//
//  CheckmateDetector.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum CheckmateDetector {

    // Checkmate occurs only if the king is in check and the player has no legal moves left.
    static func isCheckmate(for color: PieceColor, in state: GameState) -> Bool {
        let isInCheck = CheckDetector.isKingInCheck(color: color, in: state)
        guard isInCheck else {
            return false
        }

        let hasLegalMove = LegalMoveGenerator.hasAnyLegalMove(for: color, in: state)
        return !hasLegalMove
    }
}
