//
//  AbilityChoiceFactory.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

// Each player receives three random ability options before the match starts.
enum AbilityChoiceFactory {
    static func makeThreeChoices() -> [Ability] {
        Array(Ability.allCases.shuffled().prefix(3))
    }
}
