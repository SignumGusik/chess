//
//  GameState+Mutations.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//
import Foundation

extension GameState {
    mutating func updatePiece(_ updatedPiece: Piece) {
        guard let index = pieces.firstIndex(where: { $0.id == updatedPiece.id }) else {
            return
        }
        pieces[index] = updatedPiece
    }

    mutating func capturePiece(withID id: UUID) {
        guard let index = pieces.firstIndex(where: { $0.id == id }) else {
            return
        }
        pieces[index].isCaptured = true
    }

    mutating func movePiece(withID id: UUID, to position: BoardPosition) {
        guard let index = pieces.firstIndex(where: { $0.id == id }) else {
            return
        }

        pieces[index].position = position
        pieces[index].hasMoved = true
    }

    mutating func addSnapshot() {
        let snapshot = GameSnapshot(
            pieces: pieces,
            currentTurn: currentTurn,
            moves: moves,
            moveCount: moveCount,
            result: result,
            abilities: abilities,
            enPassantTarget: enPassantTarget,
            checkedKingColor: checkedKingColor,
            fullMoveNumber: fullMoveNumber
        )
        snapshots.append(snapshot)
    }
}
