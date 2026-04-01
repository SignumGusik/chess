//
//  GameState.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation

struct GameState: Codable, Equatable {
    var pieces: [Piece]
    var currentTurn: PieceColor
    var players: [Player]
    var abilities: [PlayerAbilitySet]
    var moves: [ChessMove]
    var result: GameResult
    var moveCount: Int
    var fullMoveNumber: Int
    var isPaused: Bool
    var checkedKingColor: PieceColor?
    var pendingPromotionPawnID: UUID?
    var enPassantTarget: BoardPosition?
    var snapshots: [GameSnapshot]

    var activePieces: [Piece] {
        pieces.filter { !$0.isCaptured }
    }

    func player(for color: PieceColor) -> Player? {
        players.first { $0.color == color }
    }

    func currentAbilitySet() -> PlayerAbilitySet? {
        abilities.first { $0.color == currentTurn }
    }

    func abilitySet(for color: PieceColor) -> PlayerAbilitySet? {
        abilities.first { $0.color == color }
    }
}

extension GameState {
    func piece(at position: BoardPosition) -> Piece? {
        activePieces.first { $0.position == position }
    }

    func king(for color: PieceColor) -> Piece? {
        activePieces.first { $0.type == .king && $0.color == color }
    }

    func containsPiece(at position: BoardPosition) -> Bool {
        piece(at: position) != nil
    }

    func containsFriendlyPiece(at position: BoardPosition, color: PieceColor) -> Bool {
        guard let piece = piece(at: position) else {
            return false
        }
        return piece.color == color
    }

    func containsEnemyPiece(at position: BoardPosition, color: PieceColor) -> Bool {
        guard let piece = piece(at: position) else {
            return false
        }
        return piece.color != color
    }
}

extension GameState {
    func piece(withID id: UUID) -> Piece? {
        pieces.first { $0.id == id }
    }

    func activePiece(withID id: UUID) -> Piece? {
        activePieces.first { $0.id == id }
    }
}

extension GameState {
    mutating func updateAbilitySet(_ updatedSet: PlayerAbilitySet) {
        guard let index = abilities.firstIndex(where: { $0.color == updatedSet.color }) else {
            return
        }
        abilities[index] = updatedSet
    }
}
