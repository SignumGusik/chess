//
//  AbilityValidationError.swift
//  chess
//
//  Created by Диана on 01/04/2026.
//

enum AbilityValidationError: Error {
    case message(String)

    var text: String {
        switch self {
        case let .message(text):
            return text
        }
    }
}
