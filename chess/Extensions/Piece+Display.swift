//
//  Piece+Display.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

extension Piece {
    var displaySymbol: String {
        switch (type, color) {
        case (.king, .white):
            return AppConstants.Strings.Symbols.whiteKing
        case (.queen, .white):
            return AppConstants.Strings.Symbols.whiteQueen
        case (.rook, .white):
            return AppConstants.Strings.Symbols.whiteRook
        case (.bishop, .white):
            return AppConstants.Strings.Symbols.whiteBishop
        case (.knight, .white):
            return AppConstants.Strings.Symbols.whiteKnight
        case (.pawn, .white):
            return AppConstants.Strings.Symbols.whitePawn
        case (.king, .black):
            return AppConstants.Strings.Symbols.blackKing
        case (.queen, .black):
            return AppConstants.Strings.Symbols.blackQueen
        case (.rook, .black):
            return AppConstants.Strings.Symbols.blackRook
        case (.bishop, .black):
            return AppConstants.Strings.Symbols.blackBishop
        case (.knight, .black):
            return AppConstants.Strings.Symbols.blackKnight
        case (.pawn, .black):
            return AppConstants.Strings.Symbols.blackPawn
        }
    }
}
