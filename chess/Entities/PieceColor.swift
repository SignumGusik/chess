//
//  PieceColor.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

enum PieceColor: String, Codable, CaseIterable {
    case white
    case black

    var opposite: PieceColor {
        switch self {
        case .white:
            return .black
        case .black:
            return .white
        }
    }

    var title: String {
        switch self {
        case .white:
            return "Белые"
        case .black:
            return "Чёрные"
        }
    }
}
