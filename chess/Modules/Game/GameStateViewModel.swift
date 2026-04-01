//
//  GameStateViewModel.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct GameStateViewModel {
    let boardCells: [BoardCellViewModel]
    let currentTurnText: String
    let moveHistory: [String]
    let statusText: String?
    let currentAbilityText: String?
    let moveCounterText: String
}
