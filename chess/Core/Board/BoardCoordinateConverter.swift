//
//  BoardCoordinateConverter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum BoardCoordinateConverter {

    // Convert a collection view cell index into a logical row and column on the board.
    static func indexPathItemToPosition(_ item: Int) -> BoardPosition? {
        let boardCellCount = AppConstants.Board.size * AppConstants.Board.size

        guard (0..<boardCellCount).contains(item) else {
            return nil
        }

        let row = item / AppConstants.Board.size
        let column = item % AppConstants.Board.size

        return BoardPosition(row: row, column: column)
    }

    // Convert a logical board position back into a flat collection view index.
    static func positionToIndex(_ position: BoardPosition) -> Int? {
        guard position.isValid else {
            return nil
        }

        return position.row * AppConstants.Board.size + position.column
    }
}
