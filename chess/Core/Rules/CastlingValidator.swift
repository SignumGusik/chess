//
//  CastlingValidator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum CastlingValidator {

    // Castling is allowed only if the king and rook have not moved and the king is not in check.
    static func castlingMoves(for king: Piece, in state: GameState) -> [BoardPosition] {
        guard king.type == .king, !king.hasMoved else {
            return []
        }

        guard !CheckDetector.isKingInCheck(color: king.color, in: state) else {
            return []
        }

        var moves: [BoardPosition] = []

        if canCastleKingside(for: king, in: state),
           let target = king.position.offsetBy(
                rowDelta: 0,
                columnDelta: AppConstants.GameDefaults.castlingColumnShift
           ) {
            moves.append(target)
        }

        if canCastleQueenside(for: king, in: state),
           let target = king.position.offsetBy(
                rowDelta: 0,
                columnDelta: -AppConstants.GameDefaults.castlingColumnShift
           ) {
            moves.append(target)
        }

        return moves
    }

    // Kingside castling requires empty squares between the king and rook and a safe king path.
    private static func canCastleKingside(for king: Piece, in state: GameState) -> Bool {
        let row = king.position.row
        let rookPosition = BoardPosition(
            row: row,
            column: AppConstants.Board.kingsideRookColumn
        )

        guard let rook = state.piece(at: rookPosition),
              rook.type == .rook,
              rook.color == king.color,
              !rook.hasMoved else {
            return false
        }

        let path = [
            BoardPosition(row: row, column: AppConstants.Board.kingsidePathFirstColumn),
            BoardPosition(row: row, column: AppConstants.Board.kingsidePathSecondColumn)
        ]

        for square in path where state.containsPiece(at: square) {
            return false
        }

        let kingPath = path

        for square in kingPath {
            let simulated = MoveSimulator.simulateMove(
                piece: king,
                from: king.position,
                to: square,
                in: state
            )

            if CheckDetector.isKingInCheck(color: king.color, in: simulated) {
                return false
            }
        }

        return true
    }

    // Queenside castling also checks the extra empty square between the rook and the king.
    private static func canCastleQueenside(for king: Piece, in state: GameState) -> Bool {
        let row = king.position.row
        let rookPosition = BoardPosition(
            row: row,
            column: AppConstants.Board.queensideRookColumn
        )

        guard let rook = state.piece(at: rookPosition),
              rook.type == .rook,
              rook.color == king.color,
              !rook.hasMoved else {
            return false
        }

        let emptySquares = [
            BoardPosition(row: row, column: AppConstants.Board.queensideEmptyFirstColumn),
            BoardPosition(row: row, column: AppConstants.Board.queensideEmptySecondColumn),
            BoardPosition(row: row, column: AppConstants.Board.queensideEmptyThirdColumn)
        ]

        for square in emptySquares where state.containsPiece(at: square) {
            return false
        }

        let kingPath = [
            BoardPosition(row: row, column: AppConstants.Board.queensideKingPathFirstColumn),
            BoardPosition(row: row, column: AppConstants.Board.queensideKingPathSecondColumn)
        ]

        for square in kingPath {
            let simulated = MoveSimulator.simulateMove(
                piece: king,
                from: king.position,
                to: square,
                in: state
            )

            if CheckDetector.isKingInCheck(color: king.color, in: simulated) {
                return false
            }
        }

        return true
    }
}
