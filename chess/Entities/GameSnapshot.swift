//
//  GameSnapshot.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct GameSnapshot: Codable, Equatable {
    let pieces: [Piece]
    let currentTurn: PieceColor
    let moves: [ChessMove]
    let moveCount: Int
    let result: GameResult
    let abilities: [PlayerAbilitySet]
    let enPassantTarget: BoardPosition?
    let checkedKingColor: PieceColor?
    let fullMoveNumber: Int
}
