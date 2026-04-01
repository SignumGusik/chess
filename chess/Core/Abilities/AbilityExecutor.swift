//
//  AbilityExecutor.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum AbilityExecutor {

    // Special abilities update the same game state model as normal moves to keep history consistent.
    static func useCurrentPlayerAbility(
        in state: GameState,
        targetPosition: BoardPosition?
    ) -> AbilityUseResult {
        switch AbilityValidator.canUseCurrentPlayerAbility(in: state) {
        case let .failure(error):
            return .unavailable(message: error.text)

        case let .success(ability):
            switch ability {
            case .spawnPiece:
                return useSpawnPiece(in: state, targetPosition: targetPosition)
            case .kingAsQueen:
                return useKingAsQueen(in: state)
            case .ballisticRocket:
                return useBallisticRocket(in: state, targetPosition: targetPosition)
            case .pawnUpgradeAfterFortyMoves:
                return usePawnUpgradeAfterFortyMoves(in: state)
            case .timeMachine:
                return useTimeMachine(in: state)
            }
        }
    }
}

private extension AbilityExecutor {

    // The spawn ability currently creates a knight on an empty square in the player's own half.
    static func useSpawnPiece(
        in state: GameState,
        targetPosition: BoardPosition?
    ) -> AbilityUseResult {
        guard let targetPosition else {
            return .targetSelectionRequired(
                message: AppConstants.Strings.AbilityMessages.selectEmptyCellForSpawn
            )
        }

        guard targetPosition.isValid else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.invalidCell
            )
        }

        guard !state.containsPiece(at: targetPosition) else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.cellOccupied
            )
        }

        let isOwnHalf: Bool
        switch state.currentTurn {
        case .white:
            isOwnHalf = targetPosition.row >= AppConstants.Board.halfIndexForWhite
        case .black:
            isOwnHalf = targetPosition.row <= AppConstants.Board.halfIndexForBlack
        }

        guard isOwnHalf else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.spawnOnlyOnOwnHalf
            )
        }

        guard var abilitySet = state.currentAbilitySet() else {
            return .unavailable(
                message: AppConstants.Strings.AbilityMessages.abilitySetNotFound
            )
        }

        var updatedState = state
        updatedState.addSnapshot()

        let newPiece = Piece(
            type: .knight,
            color: state.currentTurn,
            position: targetPosition,
            hasMoved: true,
            isCaptured: false
        )

        updatedState.pieces.append(newPiece)

        if CheckDetector.isKingInCheck(color: state.currentTurn, in: updatedState) {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.cannotLeaveOwnKingInCheck
            )
        }

        abilitySet.hasUsedMainAbility = true
        updatedState.updateAbilitySet(abilitySet)

        let notation = AppConstants.Strings.Notation.abilitySpawnPrefix + "(\(targetPosition.notation))"

        let move = ChessMove(
            from: targetPosition,
            to: targetPosition,
            movedPieceID: newPiece.id,
            movedPieceType: newPiece.type,
            movedPieceColor: newPiece.color,
            notation: notation
        )

        updatedState.moves.append(move)
        updatedState.currentTurn = updatedState.currentTurn.opposite
        updatedState.moveCount += 1

        if state.currentTurn == .black {
            updatedState.fullMoveNumber += 1
        }

        updatedState.checkedKingColor = CheckDetector.checkedKingColor(in: updatedState)
        updatedState.result = .ongoing

        let opponentColor = newPiece.color.opposite

        if CheckmateDetector.isCheckmate(for: opponentColor, in: updatedState) {
            updatedState.result = .checkmate(winner: newPiece.color)
        } else if StalemateDetector.isStalemate(for: opponentColor, in: updatedState) {
            updatedState.result = .stalemate
        } else if CheckDetector.isKingInCheck(color: opponentColor, in: updatedState) {
            updatedState.result = .check(checkedKing: opponentColor)
            updatedState.checkedKingColor = opponentColor
        }

        return .success(
            updatedState,
            message: AppConstants.Strings.AbilityMessages.spawnSuccessPrefix + targetPosition.notation
        )
    }

    // This ability enables a temporary mode where the king may move like a queen once.
    static func useKingAsQueen(in state: GameState) -> AbilityUseResult {
        guard var abilitySet = state.currentAbilitySet() else {
            return .unavailable(
                message: AppConstants.Strings.AbilityMessages.abilitySetNotFound
            )
        }

        guard !abilitySet.pendingKingAsQueenMove else {
            return .unavailable(
                message: AppConstants.Strings.AbilityMessages.kingAsQueenAlreadyActive
            )
        }

        var updatedState = state
        abilitySet.pendingKingAsQueenMove = true
        updatedState.updateAbilitySet(abilitySet)

        return .success(
            updatedState,
            message: AppConstants.Strings.AbilityMessages.kingAsQueenSuccess
        )
    }

    // The rocket ability removes an enemy piece, but never a king or a queen.
    static func useBallisticRocket(
        in state: GameState,
        targetPosition: BoardPosition?
    ) -> AbilityUseResult {
        guard let targetPosition else {
            return .targetSelectionRequired(
                message: AppConstants.Strings.AbilityMessages.selectEnemyPieceForRocket
            )
        }

        guard let targetPiece = state.piece(at: targetPosition) else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.noPieceOnSelectedCell
            )
        }

        guard targetPiece.color != state.currentTurn else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.cannotDestroyOwnPiece
            )
        }

        guard targetPiece.type != .king, targetPiece.type != .queen else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.cannotDestroyKingOrQueen
            )
        }

        guard var abilitySet = state.currentAbilitySet() else {
            return .unavailable(
                message: AppConstants.Strings.AbilityMessages.abilitySetNotFound
            )
        }

        var updatedState = state
        updatedState.addSnapshot()
        updatedState.capturePiece(withID: targetPiece.id)

        if CheckDetector.isKingInCheck(color: state.currentTurn, in: updatedState) {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.rocketCannotLeaveOwnKingInCheck
            )
        }

        abilitySet.hasUsedMainAbility = true
        updatedState.updateAbilitySet(abilitySet)

        let notation = AppConstants.Strings.Notation.abilityRocketPrefix + targetPosition.notation

        let move = ChessMove(
            from: targetPosition,
            to: targetPosition,
            movedPieceID: targetPiece.id,
            movedPieceType: targetPiece.type,
            movedPieceColor: targetPiece.color,
            capturedPieceID: targetPiece.id,
            capturedPieceType: targetPiece.type,
            notation: notation
        )

        updatedState.moves.append(move)
        updatedState.currentTurn = updatedState.currentTurn.opposite
        updatedState.moveCount += 1

        if state.currentTurn == .black {
            updatedState.fullMoveNumber += 1
        }

        updatedState.checkedKingColor = nil
        updatedState.result = .ongoing

        let opponentColor = state.currentTurn.opposite

        if CheckmateDetector.isCheckmate(for: opponentColor, in: updatedState) {
            updatedState.result = .checkmate(winner: state.currentTurn)
        } else if StalemateDetector.isStalemate(for: opponentColor, in: updatedState) {
            updatedState.result = .stalemate
        } else if CheckDetector.isKingInCheck(color: opponentColor, in: updatedState) {
            updatedState.result = .check(checkedKing: opponentColor)
            updatedState.checkedKingColor = opponentColor
        }

        return .successWithRocket(
            updatedState,
            target: targetPosition,
            message: AppConstants.Strings.AbilityMessages.rocketSuccessPrefix
                + targetPosition.notation
                + AppConstants.Strings.AbilityMessages.rocketSuccessSuffix
        )
    }

    // The pawn upgrade ability becomes available only after the required number of full moves.
    static func usePawnUpgradeAfterFortyMoves(in state: GameState) -> AbilityUseResult {
        guard var abilitySet = state.currentAbilitySet() else {
            return .unavailable(
                message: AppConstants.Strings.AbilityMessages.abilitySetNotFound
            )
        }

        guard let pawn = state.activePieces.first(where: {
            $0.color == state.currentTurn && $0.type == .pawn
        }) else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.noPawnForUpgrade
            )
        }

        var updatedState = state
        updatedState.addSnapshot()

        guard let pawnIndex = updatedState.pieces.firstIndex(where: { $0.id == pawn.id }) else {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.pawnNotFound
            )
        }

        updatedState.pieces[pawnIndex] = Piece(
            id: pawn.id,
            type: .knight,
            color: pawn.color,
            position: pawn.position,
            hasMoved: pawn.hasMoved,
            isCaptured: false
        )

        if CheckDetector.isKingInCheck(color: state.currentTurn, in: updatedState) {
            return .invalidTarget(
                message: AppConstants.Strings.AbilityMessages.pawnUpgradeLeavesKingInCheck
            )
        }

        abilitySet.hasUsedMainAbility = true
        updatedState.updateAbilitySet(abilitySet)

        let notation = AppConstants.Strings.Notation.abilityPawnUpgradePrefix + "(\(pawn.position.notation))"

        let move = ChessMove(
            from: pawn.position,
            to: pawn.position,
            movedPieceID: pawn.id,
            movedPieceType: .pawn,
            movedPieceColor: pawn.color,
            promotionPieceType: .knight,
            notation: notation
        )

        updatedState.moves.append(move)
        updatedState.currentTurn = updatedState.currentTurn.opposite
        updatedState.moveCount += 1

        if state.currentTurn == .black {
            updatedState.fullMoveNumber += 1
        }

        updatedState.checkedKingColor = nil
        updatedState.result = .ongoing

        let opponentColor = state.currentTurn.opposite

        if CheckmateDetector.isCheckmate(for: opponentColor, in: updatedState) {
            updatedState.result = .checkmate(winner: state.currentTurn)
        } else if StalemateDetector.isStalemate(for: opponentColor, in: updatedState) {
            updatedState.result = .stalemate
        } else if CheckDetector.isKingInCheck(color: opponentColor, in: updatedState) {
            updatedState.result = .check(checkedKing: opponentColor)
            updatedState.checkedKingColor = opponentColor
        }

        return .success(
            updatedState,
            message: AppConstants.Strings.AbilityMessages.pawnUpgradeSuccess
        )
    }

    // The time machine ability unlocks undo by allowing the match to restore saved snapshots.
    static func useTimeMachine(in state: GameState) -> AbilityUseResult {
        .success(
            state,
            message: AppConstants.Strings.AbilityMessages.timeMachineActive
        )
    }
}
