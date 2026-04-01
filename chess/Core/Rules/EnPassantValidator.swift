//
//  EnPassantValidator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum EnPassantValidator {

    static func enPassantMoves(for pawn: Piece, in state: GameState) -> [BoardPosition] {
        guard pawn.type == .pawn,
              let target = state.enPassantTarget else {
            return []
        }

        let forward = pawn.color == .white ? -1 : 1

        let possibleTargets = [-1, 1].compactMap { columnDelta in
            pawn.position.offsetBy(rowDelta: forward, columnDelta: columnDelta)
        }
        

        return possibleTargets.contains(target) ? [target] : []
    }
}
