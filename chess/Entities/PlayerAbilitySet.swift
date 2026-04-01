//
//  PlayerAbilitySet.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct PlayerAbilitySet: Codable, Equatable {
    let color: PieceColor
    let selectedAbility: Ability?
    var hasUsedMainAbility: Bool
    var canUseTimeMachine: Bool
    var availableChoices: [Ability]
    var pendingKingAsQueenMove: Bool

    init(
        color: PieceColor,
        selectedAbility: Ability?,
        hasUsedMainAbility: Bool = false,
        canUseTimeMachine: Bool = true,
        availableChoices: [Ability] = [],
        pendingKingAsQueenMove: Bool = false
    ) {
        self.color = color
        self.selectedAbility = selectedAbility
        self.hasUsedMainAbility = hasUsedMainAbility
        self.canUseTimeMachine = canUseTimeMachine
        self.availableChoices = availableChoices
        self.pendingKingAsQueenMove = pendingKingAsQueenMove
    }
}
