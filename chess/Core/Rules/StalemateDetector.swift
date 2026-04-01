//
//  StalemateDetector.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum StalemateDetector {

    // Stalemate occurs when a player has no legal moves but is not currently in check.
    static func isStalemate(for color: PieceColor, in state: GameState) -> Bool {
        let isInCheck = CheckDetector.isKingInCheck(color: color, in: state)
        guard !isInCheck else {
            return false
        }

        let hasLegalMove = LegalMoveGenerator.hasAnyLegalMove(for: color, in: state)
        return !hasLegalMove
    }
}
