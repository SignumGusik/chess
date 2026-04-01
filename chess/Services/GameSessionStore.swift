//
//  GameSessionStore.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

final class GameSessionStore {

    static let shared = GameSessionStore()

    weak var activeGameSaver: GameSaving?

    private init() {
    }
}

protocol GameSaving: AnyObject {
    func saveCurrentGame()
}
