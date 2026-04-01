//
//  BoardCellViewModel.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct BoardCellViewModel {
    let position: BoardPosition
    let pieceText: String?
    let pieceColor: PieceColor?
    let isHighlighted: Bool
    let isSelected: Bool
    let isCheck: Bool
}
