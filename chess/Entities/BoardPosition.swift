//
//  BoardPosition.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct BoardPosition: Codable, Equatable, Hashable {
    let row: Int
    let column: Int

    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    // Board positions are validated to stay strictly inside the 8x8 chess board.
    var isValid: Bool {
        (0..<AppConstants.Board.size).contains(row) &&
        (0..<AppConstants.Board.size).contains(column)
    }

    // Algebraic notation is used to display positions in a readable chess format like e4.
    var notation: String {
        guard isValid else {
            return AppConstants.Strings.Board.invalidNotation
        }

        let scalarValue = AppConstants.Board.notationFileBase + UInt32(column)
        let fileScalar = UnicodeScalar(scalarValue) ?? UnicodeScalar(AppConstants.Board.notationFileBase)!
        let file = Character(fileScalar)
        let rank = AppConstants.Board.rankMax - row

        return "\(file)\(rank)"
    }

    // Convert chess notation such as e2 into internal board coordinates.
    static func from(notation: String) -> BoardPosition? {
        let lowercased = notation.lowercased()
        guard lowercased.count == AppConstants.Board.notationLength else {
            return nil
        }

        let characters = Array(lowercased)

        guard let fileScalar = characters[0].unicodeScalars.first else {
            return nil
        }

        let column = Int(fileScalar.value) - Int(AppConstants.Board.notationFileBase)

        guard let rank = Int(String(characters[1])) else {
            return nil
        }

        let row = AppConstants.Board.rankMax - rank
        let position = BoardPosition(row: row, column: column)

        return position.isValid ? position : nil
    }

    // Create a neighboring board position only if the result stays inside the board.
    func offsetBy(rowDelta: Int, columnDelta: Int) -> BoardPosition? {
        let next = BoardPosition(
            row: row + rowDelta,
            column: column + columnDelta
        )
        return next.isValid ? next : nil
    }
}
