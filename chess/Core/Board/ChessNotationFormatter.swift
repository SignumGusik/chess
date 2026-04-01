//
//  ChessNotationFormatter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum ChessNotationFormatter {

    static func notation(
        for piece: Piece,
        from: BoardPosition,
        to: BoardPosition,
        capturedPiece: Piece? = nil,
        promotion: PieceType? = nil,
        isCheck: Bool = false,
        isCheckmate: Bool = false
    ) -> String {
        if piece.type == .king,
           abs(to.column - from.column) == AppConstants.GameDefaults.castlingColumnShift {
            let castling = to.column > from.column
                ? AppConstants.Strings.Notation.castlingShort
                : AppConstants.Strings.Notation.castlingLong

            if isCheckmate {
                return castling + AppConstants.Strings.Notation.checkmate
            }

            if isCheck {
                return castling + AppConstants.Strings.Notation.check
            }

            return castling
        }

        var result = piece.type.shortNotation

        if piece.type == .pawn, capturedPiece != nil {
            let scalarValue = AppConstants.Board.notationFileBase + UInt32(from.column)
            let fileScalar = UnicodeScalar(scalarValue) ?? UnicodeScalar(AppConstants.Board.notationFileBase)!
            let file = Character(fileScalar)
            result += String(file)
        }

        if capturedPiece != nil {
            result += AppConstants.Strings.Notation.capture
        }

        result += to.notation

        if let promotion {
            result += AppConstants.Strings.Notation.promotion + promotion.shortNotation
        }

        if isCheckmate {
            result += AppConstants.Strings.Notation.checkmate
        } else if isCheck {
            result += AppConstants.Strings.Notation.check
        }

        return result
    }
}
