//
//  GameViewModelFactory.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum GameViewModelFactory {

    // The board view model is flattened into a simple array so UICollectionView can render it easily.
    static func make(
        from state: GameState,
        selectedPosition: BoardPosition? = nil,
        highlightedPositions: [BoardPosition] = []
    ) -> GameStateViewModel {
        let highlightedSet = Set(highlightedPositions)

        let checkedKingPosition: BoardPosition?
        
        // The checked king is highlighted separately so the player can clearly see the danger.
        if let checkedColor = state.checkedKingColor {
            checkedKingPosition = state.king(for: checkedColor)?.position
        } else {
            checkedKingPosition = nil
        }

        let boardCells: [BoardCellViewModel] = (0..<AppConstants.Board.size).flatMap { row in
            (0..<AppConstants.Board.size).map { column in
                let position = BoardPosition(row: row, column: column)
                let piece = state.piece(at: position)

                return BoardCellViewModel(
                    position: position,
                    pieceText: piece?.displaySymbol,
                    pieceColor: piece?.color,
                    isHighlighted: highlightedSet.contains(position),
                    isSelected: selectedPosition == position,
                    isCheck: checkedKingPosition == position
                )
            }
        }

        let currentTurnText = AppConstants.Strings.Game.movePrefix + state.currentTurn.title
        let moveHistory = state.moves.map(\.notation)

        let statusText: String?
        switch state.result {
        case .ongoing:
            statusText = nil
        case let .check(checkedKing):
            statusText = AppConstants.Strings.Game.checkPrefix + checkedKing.title
        case let .checkmate(winner):
            statusText = AppConstants.Strings.Game.checkmatePrefix + winner.title
        case .stalemate:
            statusText = AppConstants.Strings.Game.stalemate
        }

        let currentAbilityText: String?
        
        // The current ability is intentionally hidden during the match until it is used.
        if let abilitySet = state.currentAbilitySet(), abilitySet.selectedAbility != nil {
            currentAbilityText = abilitySet.hasUsedMainAbility
                ? AppConstants.Strings.Game.abilityUsed
                : AppConstants.Strings.Game.abilityHidden
        } else {
            currentAbilityText = AppConstants.Strings.Game.abilityNotSelected
        }

        let moveCounterText = AppConstants.Strings.Game.fullMovePrefix + "\(state.fullMoveNumber)"

        return GameStateViewModel(
            boardCells: boardCells,
            currentTurnText: currentTurnText,
            moveHistory: moveHistory,
            statusText: statusText,
            currentAbilityText: currentAbilityText,
            moveCounterText: moveCounterText
        )
    }
}
