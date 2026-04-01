//
//  AbilityValidator.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//
import Foundation


enum AbilityValidator {

    // Ability usage is validated before execution to keep game rules centralized and predictable.
    static func canUseCurrentPlayerAbility(
        in state: GameState
    ) -> Result<Ability, AbilityValidationError> {
        guard
            let abilitySet = state.currentAbilitySet(),
            let ability = abilitySet.selectedAbility
        else {
            return .failure(.message(AppConstants.Strings.AbilityMessages.abilityNotSelected))
        }

        switch ability {
        case .timeMachine:
            return .success(ability)

        case .pawnUpgradeAfterFortyMoves:
            if state.fullMoveNumber < AppConstants.Ability.pawnUpgradeAvailableAfterFullMove {
                return .failure(.message(AppConstants.Strings.AbilityMessages.pawnUpgradeTooEarly))
            }

            if abilitySet.hasUsedMainAbility {
                return .failure(.message(AppConstants.Strings.AbilityMessages.abilityAlreadyUsed))
            }

            return .success(ability)

        case .spawnPiece, .kingAsQueen, .ballisticRocket:
            if abilitySet.hasUsedMainAbility {
                return .failure(.message(AppConstants.Strings.AbilityMessages.abilityAlreadyUsed))
            }

            return .success(ability)
        }
    }
}
