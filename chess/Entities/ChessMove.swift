//
//  ChessMove.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//
import Foundation

struct ChessMove: Codable, Equatable {
    let id: UUID
    let from: BoardPosition
    let to: BoardPosition
    let movedPieceID: UUID
    let movedPieceType: PieceType
    let movedPieceColor: PieceColor
    let capturedPieceID: UUID?
    let capturedPieceType: PieceType?
    let promotionPieceType: PieceType?
    let isCheck: Bool
    let isCheckmate: Bool
    let notation: String

    init(
        id: UUID = UUID(),
        from: BoardPosition,
        to: BoardPosition,
        movedPieceID: UUID,
        movedPieceType: PieceType,
        movedPieceColor: PieceColor,
        capturedPieceID: UUID? = nil,
        capturedPieceType: PieceType? = nil,
        promotionPieceType: PieceType? = nil,
        isCheck: Bool = false,
        isCheckmate: Bool = false,
        notation: String
    ) {
        self.id = id
        self.from = from
        self.to = to
        self.movedPieceID = movedPieceID
        self.movedPieceType = movedPieceType
        self.movedPieceColor = movedPieceColor
        self.capturedPieceID = capturedPieceID
        self.capturedPieceType = capturedPieceType
        self.promotionPieceType = promotionPieceType
        self.isCheck = isCheck
        self.isCheckmate = isCheckmate
        self.notation = notation
    }
}
