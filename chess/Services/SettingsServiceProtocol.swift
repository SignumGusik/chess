//
//  SettingsServiceProtocol.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

protocol SettingsServiceProtocol: AnyObject {
    func saveTheme(_ theme: AppThemeStyle)
    func loadTheme() -> AppThemeStyle
}
