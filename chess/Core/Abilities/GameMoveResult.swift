//
//  GameMoveResult.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation

enum GameMoveResult {
    case success(GameState)
    case invalidMove
    case promotionRequired(GameState, pawnColor: PieceColor)
    case check(GameState, checkedKing: PieceColor)
    case checkmate(GameState, winner: PieceColor)
    case stalemate(GameState)
}
