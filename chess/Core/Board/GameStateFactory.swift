//
//  GameStateFactory.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum GameStateFactory {

    // Build a fresh game state with initial pieces, turn order, abilities, and empty history.
    static func makeInitialState(
        whiteAbility: Ability?,
        blackAbility: Ability?,
        whiteChoices: [Ability] = [],
        blackChoices: [Ability] = []
    ) -> GameState {
        let players = [
            Player(color: .white, selectedAbility: whiteAbility),
            Player(color: .black, selectedAbility: blackAbility)
        ]

        let abilities = [
            PlayerAbilitySet(
                color: .white,
                selectedAbility: whiteAbility,
                availableChoices: whiteChoices
            ),
            PlayerAbilitySet(
                color: .black,
                selectedAbility: blackAbility,
                availableChoices: blackChoices
            )
        ]

        return GameState(
            pieces: BoardSetupFactory.makeInitialPieces(),
            currentTurn: .white,
            players: players,
            abilities: abilities,
            moves: [],
            result: .ongoing,
            moveCount: 0,
            fullMoveNumber: 1,
            isPaused: false,
            checkedKingColor: nil,
            pendingPromotionPawnID: nil,
            enPassantTarget: nil,
            snapshots: []
        )
    }
}
