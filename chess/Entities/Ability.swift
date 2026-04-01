//
//  Ability.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum Ability: String, Codable, CaseIterable {
    case spawnPiece
    case kingAsQueen
    case ballisticRocket
    case pawnUpgradeAfterFortyMoves
    case timeMachine

    var title: String {
        switch self {
        case .spawnPiece:
            return "Призыв фигуры"
        case .kingAsQueen:
            return "Король как ферзь"
        case .ballisticRocket:
            return "Баллистическая ракета"
        case .pawnUpgradeAfterFortyMoves:
            return "Усиление пешки"
        case .timeMachine:
            return "Машина времени"
        }
    }

    var description: String {
        switch self {
        case .spawnPiece:
            return "Один раз за игру можно поставить новую фигуру, кроме ферзя, если после этого ваш король не под шахом."
        case .kingAsQueen:
            return "Один раз за игру можно сходить королём как ферзём."
        case .ballisticRocket:
            return "Один раз за игру можно уничтожить фигуру соперника, кроме короля и ферзя, если это не оставляет шах."
        case .pawnUpgradeAfterFortyMoves:
            return "После 40-го хода можно превратить одну пешку в фигуру стоимостью 3."
        case .timeMachine:
            return "По договорённости игроков можно откатывать ходы."
        }
    }

    var isTargetRequired: Bool {
        switch self {
        case .spawnPiece, .ballisticRocket:
            return true
        case .kingAsQueen, .pawnUpgradeAfterFortyMoves, .timeMachine:
            return false
        }
    }
}
