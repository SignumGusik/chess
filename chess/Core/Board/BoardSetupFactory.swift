//
//  BoardSetupFactory.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum BoardSetupFactory {

    // The initial board is generated in standard chess order for both colors.
    static func makeInitialPieces() -> [Piece] {
        var pieces: [Piece] = []

        pieces.append(contentsOf: makeBackRank(
            for: .black,
            row: AppConstants.Board.blackBackRankRow
        ))
        pieces.append(contentsOf: makePawns(
            for: .black,
            row: AppConstants.Board.blackPawnStartRow
        ))

        pieces.append(contentsOf: makePawns(
            for: .white,
            row: AppConstants.Board.whitePawnStartRow
        ))
        pieces.append(contentsOf: makeBackRank(
            for: .white,
            row: AppConstants.Board.whiteBackRankRow
        ))

        return pieces
    }

    // The back rank contains the major and minor pieces in their normal starting positions.
    private static func makeBackRank(for color: PieceColor, row: Int) -> [Piece] {
        [
            Piece(type: .rook, color: color, position: BoardPosition(row: row, column: 0)),
            Piece(type: .knight, color: color, position: BoardPosition(row: row, column: 1)),
            Piece(type: .bishop, color: color, position: BoardPosition(row: row, column: 2)),
            Piece(type: .queen, color: color, position: BoardPosition(row: row, column: 3)),
            Piece(type: .king, color: color, position: BoardPosition(row: row, column: 4)),
            Piece(type: .bishop, color: color, position: BoardPosition(row: row, column: 5)),
            Piece(type: .knight, color: color, position: BoardPosition(row: row, column: 6)),
            Piece(type: .rook, color: color, position: BoardPosition(row: row, column: 7))
        ]
    }

    // Create eight pawns for the specified color on their starting row.
    private static func makePawns(for color: PieceColor, row: Int) -> [Piece] {
        (0..<AppConstants.Board.size).map { column in
            Piece(
                type: .pawn,
                color: color,
                position: BoardPosition(row: row, column: column)
            )
        }
    }
}
