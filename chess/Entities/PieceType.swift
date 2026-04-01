//
//  PieceType.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum PieceType: String, Codable, CaseIterable {
    case king
    case queen
    case rook
    case bishop
    case knight
    case pawn

    var title: String {
        switch self {
        case .king:
            return "Король"
        case .queen:
            return "Ферзь"
        case .rook:
            return "Ладья"
        case .bishop:
            return "Слон"
        case .knight:
            return "Конь"
        case .pawn:
            return "Пешка"
        }
    }

    var shortNotation: String {
        switch self {
        case .king:
            return "K"
        case .queen:
            return "Q"
        case .rook:
            return "R"
        case .bishop:
            return "B"
        case .knight:
            return "N"
        case .pawn:
            return ""
        }
    }

    var materialValue: Int {
        switch self {
        case .king:
            return 1000
        case .queen:
            return 9
        case .rook:
            return 5
        case .bishop, .knight:
            return 3
        case .pawn:
            return 1
        }
    }
}
