//
//  UIColor+AppColors.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

extension UIColor {
    static let boardLight = UIColor(red: 240 / 255, green: 217 / 255, blue: 181 / 255, alpha: 1)
    static let boardDark = UIColor(red: 181 / 255, green: 136 / 255, blue: 99 / 255, alpha: 1)

    static let boardSelected = UIColor.systemYellow.withAlphaComponent(0.45)
    static let boardHighlighted = UIColor.systemGreen.withAlphaComponent(0.35)
    static let boardCheck = UIColor.systemRed.withAlphaComponent(0.45)

    static let boardBorder = UIColor.separator
    static let appBackground = UIColor.systemBackground
    static let secondaryPanel = UIColor.secondarySystemBackground
}
