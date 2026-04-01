//
//  MoveGenerator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum MoveGenerator {

    // The move generator builds raw moves based on piece type before king safety is checked.
    static func generateMoves(for piece: Piece, in state: GameState) -> [BoardPosition] {
        guard !piece.isCaptured else {
            return []
        }

        // When the special mode is active, the king temporarily moves like a queen.
        if piece.type == .king,
           let abilitySet = state.abilitySet(for: piece.color),
           abilitySet.pendingKingAsQueenMove {
            return generateSlidingMoves(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.queen
            )
        }

        switch piece.type {
        case .pawn:
            return generatePawnMoves(for: piece, in: state)
        case .rook:
            return generateSlidingMoves(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.rook
            )
        case .bishop:
            return generateSlidingMoves(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.bishop
            )
        case .queen:
            return generateSlidingMoves(
                for: piece,
                in: state,
                directions: AppConstants.MoveDirections.queen
            )
        case .knight:
            return generateKnightMoves(for: piece, in: state)
        case .king:
            return generateKingMoves(for: piece, in: state)
                + CastlingValidator.castlingMoves(for: piece, in: state)
        }
    }

    // Pawn movement is handled separately because forward moves and captures follow different rules.
    private static func generatePawnMoves(for piece: Piece, in state: GameState) -> [BoardPosition] {
        var moves: [BoardPosition] = []

        let forward = piece.color == .white
            ? AppConstants.GameDefaults.whiteForwardStep
            : AppConstants.GameDefaults.blackForwardStep

        let startRow = piece.color == .white
            ? AppConstants.Board.whitePawnStartRow
            : AppConstants.Board.blackPawnStartRow

        if let oneStep = piece.position.offsetBy(rowDelta: forward, columnDelta: 0),
           !state.containsPiece(at: oneStep) {
            moves.append(oneStep)

            if piece.position.row == startRow,
               let twoStep = piece.position.offsetBy(
                    rowDelta: forward * AppConstants.GameDefaults.doublePawnMoveDistance,
                    columnDelta: 0
               ),
               !state.containsPiece(at: twoStep) {
                moves.append(twoStep)
            }
        }

        for columnDelta in AppConstants.MoveOffsets.pawnCaptureColumns {
            if let diagonal = piece.position.offsetBy(rowDelta: forward, columnDelta: columnDelta),
               state.containsEnemyPiece(at: diagonal, color: piece.color) {
                moves.append(diagonal)
            }
        }

        moves.append(contentsOf: EnPassantValidator.enPassantMoves(for: piece, in: state))
        return moves
    }

    private static func generateKnightMoves(for piece: Piece, in state: GameState) -> [BoardPosition] {
        AppConstants.MoveOffsets.knight.compactMap { rowDelta, columnDelta in
            guard let target = piece.position.offsetBy(rowDelta: rowDelta, columnDelta: columnDelta) else {
                return nil
            }

            if state.containsFriendlyPiece(at: target, color: piece.color) {
                return nil
            }

            return target
        }
    }

    private static func generateKingMoves(for piece: Piece, in state: GameState) -> [BoardPosition] {
        AppConstants.MoveOffsets.king.compactMap { rowDelta, columnDelta in
            guard let target = piece.position.offsetBy(rowDelta: rowDelta, columnDelta: columnDelta) else {
                return nil
            }

            if state.containsFriendlyPiece(at: target, color: piece.color) {
                return nil
            }

            return target
        }
    }

    // Sliding pieces continue moving in one direction until blocked by a piece or board edge.
    private static func generateSlidingMoves(
        for piece: Piece,
        in state: GameState,
        directions: [(Int, Int)]
    ) -> [BoardPosition] {
        var moves: [BoardPosition] = []

        for (rowDelta, columnDelta) in directions {
            var current = piece.position

            while let next = current.offsetBy(rowDelta: rowDelta, columnDelta: columnDelta) {
                if state.containsFriendlyPiece(at: next, color: piece.color) {
                    break
                }

                if state.containsEnemyPiece(at: next, color: piece.color) {
                    moves.append(next)
                    break
                }

                moves.append(next)
                current = next
            }
        }

        return moves
    }
}
