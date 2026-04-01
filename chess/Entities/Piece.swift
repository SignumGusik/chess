//
//  Piece.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//
import Foundation

struct Piece: Codable, Equatable, Identifiable {
    let id: UUID
    let type: PieceType
    let color: PieceColor
    var position: BoardPosition
    var hasMoved: Bool
    var isCaptured: Bool

    init(
        id: UUID = UUID(),
        type: PieceType,
        color: PieceColor,
        position: BoardPosition,
        hasMoved: Bool = false,
        isCaptured: Bool = false
    ) {
        self.id = id
        self.type = type
        self.color = color
        self.position = position
        self.hasMoved = hasMoved
        self.isCaptured = isCaptured
    }
}
