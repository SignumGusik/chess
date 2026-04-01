//
//  GamePersistenceService.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation

final class GamePersistenceService: GamePersistenceServiceProtocol {

    private let key = AppConstants.StorageKeys.savedChessGame

    func save(_ state: GameState) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(state) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func load() -> GameState? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(GameState.self, from: data)
    }

    func hasSavedGame() -> Bool {
        UserDefaults.standard.data(forKey: key) != nil
    }

    func clearSavedGame() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
