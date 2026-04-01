//
//  MoveApplier.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum MoveApplier {

    // Before applying a move, the current state is saved as a snapshot for undo support.
    static func applyMove(
        piece: Piece,
        from: BoardPosition,
        to: BoardPosition,
        in state: GameState
    ) -> GameState {
        var updatedState = state
        updatedState.addSnapshot()

        var capturedPiece = updatedState.piece(at: to)

        // En passant capture is handled separately because the captured pawn is not on the target square.
        if piece.type == .pawn,
           capturedPiece == nil,
           from.column != to.column,
           let enPassantTarget = updatedState.enPassantTarget,
           enPassantTarget == to {
            let capturedPawnPosition = BoardPosition(row: from.row, column: to.column)
            capturedPiece = updatedState.piece(at: capturedPawnPosition)
        }

        if let capturedPiece {
            updatedState.capturePiece(withID: capturedPiece.id)
        }

        updatedState.movePiece(withID: piece.id, to: to)
        updatedState.currentTurn = updatedState.currentTurn.opposite
        updatedState.moveCount += 1

        // A full move counter increases only after black moves, matching chess notation rules.
        if piece.color == .black {
            updatedState.fullMoveNumber += 1
        }

        // Castling moves both the king and the corresponding rook in a single action.
        if piece.type == .king,
           abs(to.column - from.column) == AppConstants.GameDefaults.castlingColumnShift {
            let row = from.row

            if to.column == AppConstants.Board.kingsideKingTargetColumn {
                let rookFrom = BoardPosition(row: row, column: AppConstants.Board.kingsideRookColumn)
                let rookTo = BoardPosition(row: row, column: AppConstants.Board.kingsideRookTargetColumn)

                if let rook = updatedState.piece(at: rookFrom) {
                    updatedState.movePiece(withID: rook.id, to: rookTo)
                }
            } else if to.column == AppConstants.Board.queensideKingTargetColumn {
                let rookFrom = BoardPosition(row: row, column: AppConstants.Board.queensideRookColumn)
                let rookTo = BoardPosition(row: row, column: AppConstants.Board.queensideRookTargetColumn)

                if let rook = updatedState.piece(at: rookFrom) {
                    updatedState.movePiece(withID: rook.id, to: rookTo)
                }
            }
        }

        if piece.type == .king,
           var abilitySet = updatedState.abilitySet(for: piece.color),
           abilitySet.pendingKingAsQueenMove {
            abilitySet.pendingKingAsQueenMove = false
            abilitySet.hasUsedMainAbility = true
            updatedState.updateAbilitySet(abilitySet)
        }

        let opponentColor = piece.color.opposite
        let isCheck = CheckDetector.isKingInCheck(color: opponentColor, in: updatedState)
        let isCheckmate = CheckmateDetector.isCheckmate(for: opponentColor, in: updatedState)
        let isStalemate = StalemateDetector.isStalemate(for: opponentColor, in: updatedState)

        let notation = ChessNotationFormatter.notation(
            for: piece,
            from: from,
            to: to,
            capturedPiece: capturedPiece,
            promotion: nil,
            isCheck: isCheck,
            isCheckmate: isCheckmate
        )

        let move = ChessMove(
            from: from,
            to: to,
            movedPieceID: piece.id,
            movedPieceType: piece.type,
            movedPieceColor: piece.color,
            capturedPieceID: capturedPiece?.id,
            capturedPieceType: capturedPiece?.type,
            promotionPieceType: nil,
            isCheck: isCheck,
            isCheckmate: isCheckmate,
            notation: notation
        )

        updatedState.moves.append(move)
        updatedState.checkedKingColor = isCheck ? opponentColor : nil

        if isCheckmate {
            updatedState.result = .checkmate(winner: piece.color)
        } else if isStalemate {
            updatedState.result = .stalemate
        } else if isCheck {
            updatedState.result = .check(checkedKing: opponentColor)
        } else {
            updatedState.result = .ongoing
        }
        
        // If a pawn reaches the last rank, promotion is delayed until the player chooses a piece.
        if let movedPiece = updatedState.activePiece(withID: piece.id),
           movedPiece.type == .pawn,
           (movedPiece.position.row == AppConstants.Board.whitePromotionRow ||
            movedPiece.position.row == AppConstants.Board.blackPromotionRow) {
            updatedState.pendingPromotionPawnID = movedPiece.id
        } else {
            updatedState.pendingPromotionPawnID = nil
        }

        updatedState.enPassantTarget = nil

        if piece.type == .pawn,
           abs(to.row - from.row) == AppConstants.GameDefaults.doublePawnMoveDistance {
            let middleRow = (from.row + to.row) / AppConstants.GameDefaults.movesPerFullTurn
            updatedState.enPassantTarget = BoardPosition(
                row: middleRow,
                column: from.column
            )
        }

        return updatedState
    }
}
