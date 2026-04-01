//
//  Player.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

struct Player: Codable, Equatable {
    let color: PieceColor
    var selectedAbility: Ability?
}
