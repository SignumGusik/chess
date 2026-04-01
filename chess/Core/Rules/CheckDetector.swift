//
//  CheckDetector.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum CheckDetector {

    // Check detection is based on attacked squares, not on whose turn it is.
    static func isKingInCheck(color: PieceColor, in state: GameState) -> Bool {
        guard let king = state.king(for: color) else {
            return false
        }

        let enemyPieces = state.activePieces.filter { $0.color != color }

        for enemyPiece in enemyPieces {
            let attackedSquares = attackedSquares(by: enemyPiece, in: state)
            if attackedSquares.contains(king.position) {
                return true
            }
        }

        return false
    }

    static func checkedKingColor(in state: GameState) -> PieceColor? {
        if isKingInCheck(color: .white, in: state) {
            return .white
        }

        if isKingInCheck(color: .black, in: state) {
            return .black
        }

        return nil
    }

    // Each piece type attacks squares differently, so attack generation is separated by type.
    private static func attackedSquares(by piece: Piece, in state: GameState) -> [BoardPosition] {
        switch piece.type {
        case .pawn:
            return pawnAttackSquares(for: piece)
        case .king:
            return kingAttackSquares(for: piece)
        case .knight:
            return MoveGenerator.generateMoves(for: piece, in: state)
        case .rook:
            return slidingAttackSquares(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.rook
            )
        case .bishop:
            return slidingAttackSquares(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.bishop
            )
        case .queen:
            return slidingAttackSquares(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.queen
            )
        }
    }

    // Pawn attack squares differ from pawn movement, so they are calculated separately.
    private static func pawnAttackSquares(for piece: Piece) -> [BoardPosition] {
        let forward = piece.color == .white
            ? AppConstants.GameDefaults.whiteForwardStep
            : AppConstants.GameDefaults.blackForwardStep

        return AppConstants.MoveOffsets.pawnCaptureColumns.compactMap { columnDelta in
            piece.position.offsetBy(rowDelta: forward, columnDelta: columnDelta)
        }
    }

    private static func kingAttackSquares(for piece: Piece) -> [BoardPosition] {
        AppConstants.MoveOffsets.king.compactMap { rowDelta, columnDelta in
            piece.position.offsetBy(rowDelta: rowDelta, columnDelta: columnDelta)
        }
    }

    private static func slidingAttackSquares(
        for piece: Piece,
        in state: GameState,
        directions: [(Int, Int)]
    ) -> [BoardPosition] {
        var squares: [BoardPosition] = []

        for (rowDelta, columnDelta) in directions {
            var current = piece.position

            while let next = current.offsetBy(rowDelta: rowDelta, columnDelta: columnDelta) {
                squares.append(next)

                if state.containsPiece(at: next) {
                    break
                }

                current = next
            }
        }

        return squares
    }
}
