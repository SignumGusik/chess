//
//  AbilityUseResult.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//
import Foundation

enum AbilityUseResult {
    case success(GameState, message: String)
    case successWithRocket(GameState, target: BoardPosition, message: String)
    case targetSelectionRequired(message: String)
    case invalidTarget(message: String)
    case unavailable(message: String)
}
