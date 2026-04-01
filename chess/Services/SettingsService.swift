//
//  SettingsService.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation

final class SettingsService: SettingsServiceProtocol {

    private enum Keys {
        static let theme = AppConstants.StorageKeys.appThemeStyle
    }

    func saveTheme(_ theme: AppThemeStyle) {
        UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
    }

    func loadTheme() -> AppThemeStyle {
        guard
            let rawValue = UserDefaults.standard.string(forKey: Keys.theme),
            let theme = AppThemeStyle(rawValue: rawValue)
        else {
            return .light
        }

        return theme
    }
}
