//
//  AppTheme.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum AppThemeStyle: String {
    case light
    case dark
}

// Global appearance settings are configured once at launch for a consistent UI.
enum AppTheme {
    static func apply() {
        UINavigationBar.appearance().prefersLargeTitles = true
        UINavigationBar.appearance().tintColor = .label
        UIBarButtonItem.appearance().tintColor = .label

        let settingsService = SettingsService()
        let themeService = ThemeService(settingsService: settingsService)
        themeService.apply(theme: themeService.currentTheme)
    }
}
