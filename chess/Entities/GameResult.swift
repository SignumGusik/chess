//
//  GameResult.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum GameResult: Codable, Equatable {
    case ongoing
    case check(checkedKing: PieceColor)
    case checkmate(winner: PieceColor)
    case stalemate
}
