//
//  ThemeService.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

protocol ThemeServiceProtocol: AnyObject {
    var currentTheme: AppThemeStyle { get }
    func apply(theme: AppThemeStyle)
}

final class ThemeService: ThemeServiceProtocol {

    private let settingsService: SettingsServiceProtocol

    private(set) var currentTheme: AppThemeStyle

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
        self.currentTheme = settingsService.loadTheme()
    }

    func apply(theme: AppThemeStyle) {
        currentTheme = theme
        settingsService.saveTheme(theme)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        switch theme {
        case .light:
            window.overrideUserInterfaceStyle = .light
        case .dark:
            window.overrideUserInterfaceStyle = .dark
        }
    }
}
