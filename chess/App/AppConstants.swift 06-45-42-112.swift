//
//  AppConstants.swift
//  chess
//
//  Created by Диана on 01/04/2026.
//

import UIKit

enum AppConstants {

    enum App {
        static let sceneConfigurationName = "Default Configuration"
        static let appTitle = "Шахматы"
        static let startTitle = "Старт"
        static let startDisplayTitle = "Chess"
    }

    enum StorageKeys {
        static let savedChessGame = "saved_chess_game"
        static let appThemeStyle = "app_theme_style"
    }

    enum Board {
        static let size = 8
        static let halfIndexForWhite = 4
        static let halfIndexForBlack = 3

        static let whitePawnStartRow = 6
        static let blackPawnStartRow = 1

        static let whiteBackRankRow = 7
        static let blackBackRankRow = 0

        static let kingsideRookColumn = 7
        static let queensideRookColumn = 0

        static let whitePromotionRow = 0
        static let blackPromotionRow = 7

        static let notationFileBase: UInt32 = 97 // "a"
        static let rankMax = 8
        
        static let notationLength = 2
        static let firstColumn = 0
        static let squareColorParityDivider = 2
        
        static let kingsideKingTargetColumn = 6
        static let queensideKingTargetColumn = 2

        static let kingsideRookTargetColumn = 5
        static let queensideRookTargetColumn = 3

        static let kingsidePathFirstColumn = 5
        static let kingsidePathSecondColumn = 6

        static let queensideEmptyFirstColumn = 1
        static let queensideEmptySecondColumn = 2
        static let queensideEmptyThirdColumn = 3

        static let queensideKingPathFirstColumn = 3
        static let queensideKingPathSecondColumn = 2
    }

    enum Ability {
        static let choiceCount = 3
        static let pawnUpgradeAvailableAfterFullMove = 40
    }

    enum Layout {
        static let tiny2: CGFloat = 2
        static let tiny3: CGFloat = 3
        static let tiny4: CGFloat = 4
        static let small8: CGFloat = 8
        static let small10: CGFloat = 10
        static let medium12: CGFloat = 12
        static let medium14: CGFloat = 14
        static let medium16: CGFloat = 16
        static let medium18: CGFloat = 18
        static let large20: CGFloat = 20
        static let large24: CGFloat = 24
        static let xLarge26: CGFloat = 26
        static let xxLarge28: CGFloat = 28
        static let xxxLarge34: CGFloat = 34

        static let buttonHeight44: CGFloat = 44
        static let buttonHeight48: CGFloat = 48
        static let buttonHeight50: CGFloat = 50

        static let cornerRadius8: CGFloat = 8
        static let cornerRadius12: CGFloat = 12
        static let cornerRadius14: CGFloat = 14
        static let cornerRadius16: CGFloat = 16
        static let cornerRadius18: CGFloat = 18
        static let cornerRadius20: CGFloat = 20
        static let cornerRadius24: CGFloat = 24

        static let alphaDisabled: CGFloat = 0.45
        static let alphaPaused: CGFloat = 0.9
        
        static let zero: CGFloat = 0
        static let zeroInt = 0
        static let multiLine = 0

        static let boardBorderWidth: CGFloat = 1
        static let boardPieceMinScale: CGFloat = 0.5
        static let boardCoordinateLightAlpha: CGFloat = 0.45
        static let boardCoordinateDarkAlpha: CGFloat = 0.55

        static let infoShadowOpacity: Float = 0.05
        static let infoShadowRadius: CGFloat = 10

        static let boardShadowOpacity: Float = 0.07
        static let boardShadowOffset: CGFloat = 5
        static let boardShadowRadius: CGFloat = 12

        static let startContainerShadowOpacity: Float = 0.08
    }

    enum Animation {
        static let rocketWidth: CGFloat = 20
        static let rocketHeight: CGFloat = 40
        static let rocketStartYOffset: CGFloat = -40
        static let rocketFlyDuration: TimeInterval = 0.5
        static let rocketImpactPhaseDuration: TimeInterval = 0.15
        static let rocketImpactScale: CGFloat = 1.15
        static let rocketImpactAlpha: CGFloat = 0.6
    }

    enum Fonts {
        static let authorName: CGFloat = 28
        static let authorDescription: CGFloat = 17

        static let boardPiece: CGFloat = 25
        static let boardCoordinate: CGFloat = 7

        static let gameStatus: CGFloat = 18
        static let gameMoveCounter: CGFloat = 13
        static let gameHistoryTitle: CGFloat = 15
        static let gameHistoryText: CGFloat = 13

        static let startTitle: CGFloat = 34
        static let startSubtitle: CGFloat = 16
        static let startAbility: CGFloat = 15
        static let startPrimaryButton: CGFloat = 18
        static let startSecondaryButton: CGFloat = 17
    }

    enum Strings {

        enum Author {
            static let title = "Об авторе"
            static let telegramPrefix = "Telegram: "
            static let gitHubPrefix = "GitHub: "
        }

        enum Start {
            static let subtitle = "Шахматы на одном устройстве"
            static let whiteAbilityNotSelected = "Белые: способность не выбрана"
            static let whiteAbilitySelected = "Белые: способность выбрана"
            static let blackAbilityNotSelected = "Чёрные: способность не выбрана"
            static let blackAbilitySelected = "Чёрные: способность выбрана"

            static let newGame = "Новая игра"
            static let continueGame = "Продолжить"
            static let rules = "Правила"
            static let author = "Об авторе"
            static let changeTheme = "Сменить тему"

            static let whiteAbilitySelectionTitle = "Выбор способности белых"
            static let blackAbilitySelectionTitle = "Выбор способности чёрных"
            static let abilitySelectionMessage = "Выберите одну из трёх суперспособностей"

            static let secretAbilitySelectionTitle = "Тайный выбор способности"
            static let passDeviceToWhite = "Передайте устройство белым. Когда игрок будет готов, нажмите «Продолжить»."
            static let passDeviceToBlack = "Передайте устройство чёрным. Когда игрок будет готов, нажмите «Продолжить»."
            static let continueAction = "Продолжить"
        }

        enum Game {
            static let ongoing = "Партия продолжается"
            static let noMovesYet = "Ходов пока нет"

            static let pause = "Пауза"
            static let undo = "Назад"
            static let superPower = "Суперсила"

            static let movePrefix = "Ход: "
            static let fullMovePrefix = "Полный ход: "

            static let checkPrefix = "Шах: "
            static let checkmatePrefix = "Мат. Победили "
            static let stalemate = "Пат"

            static let invalidMove = "Недопустимый ход"
            static let undoUnavailable = "Откат недоступен. Для этого нужна способность «Машина времени»"

            static let historyTitle = "История ходов"

            static let gameFinishedTitle = "Игра окончена"
            static let promotionTitle = "Повышение пешки"
            static let promotionMessagePrefix = "выбирают фигуру"

            static let pauseMenuMessage = "Игра сохранена. Выберите действие."
            static let newGameConfirmationTitle = "Новая игра"
            static let newGameConfirmationMessage = "Начать новую партию?"
            
            static let abilityUsed = "Суперспособность: использована"
            static let abilityHidden = "Суперспособность: скрыта"
            static let abilityNotSelected = "Суперспособность: не выбрана"
        }

        enum Common {
            static let ok = "ОК"
            static let cancel = "Отмена"
            static let yes = "Да"
            static let no = "Нет"
            
            static let empty = ""
            static let newLine = "\n"
        }

        enum AbilityMessages {
            static let abilityNotSelected = "Способность не выбрана"
            static let abilityAlreadyUsed = "Способность уже использована"
            static let abilitySetNotFound = "Не найден набор способностей игрока"

            static let selectEmptyCellForSpawn = "Выберите пустую клетку для призыва фигуры"
            static let invalidCell = "Некорректная клетка"
            static let cellOccupied = "Клетка занята"
            static let spawnOnlyOnOwnHalf = "Призывать фигуру можно только на своей половине доски"
            static let cannotLeaveOwnKingInCheck = "Нельзя использовать способность, если после этого ваш король под шахом"
            static let spawnSuccessPrefix = "Конь успешно призван на "

            static let kingAsQueenAlreadyActive = "Режим уже активирован"
            static let kingAsQueenSuccess = "Теперь можно сходить королём как ферзём"

            static let selectEnemyPieceForRocket = "Выберите фигуру соперника для уничтожения"
            static let noPieceOnSelectedCell = "На выбранной клетке нет фигуры"
            static let cannotDestroyOwnPiece = "Нельзя уничтожать свою фигуру"
            static let cannotDestroyKingOrQueen = "Нельзя уничтожить короля или ферзя"
            static let rocketCannotLeaveOwnKingInCheck = "Нельзя использовать ракету, если после этого ваш король под шахом"
            static let rocketSuccessPrefix = "Фигура на "
            static let rocketSuccessSuffix = " уничтожена"

            static let noPawnForUpgrade = "У текущего игрока нет пешки для усиления"
            static let pawnNotFound = "Не удалось найти пешку"
            static let pawnUpgradeLeavesKingInCheck = "После применения способности ваш король оказывается под шахом"
            static let pawnUpgradeSuccess = "Пешка усилена до коня"
            static let pawnUpgradeTooEarly = "Эта способность доступна только после 40-го полного хода"

            static let timeMachineActive = "Машина времени активна: можно откатывать ходы кнопкой «Назад»"
        }

        enum Notation {
            static let castlingShort = "O-O"
            static let castlingLong = "O-O-O"
            static let check = "+"
            static let checkmate = "#"
            static let capture = "x"
            static let promotion = "="

            static let abilitySpawnPrefix = "Ability: N@"
            static let abilityRocketPrefix = "Ability: Rocketx"
            static let abilityPawnUpgradePrefix = "Ability: PawnUpgrade@"
        }

        enum Board {
            static let invalidNotation = "invalid"
            static let cellReuseIdentifier = "BoardCell"
        }

        enum Symbols {
            static let whiteKing = "♔"
            static let whiteQueen = "♕"
            static let whiteRook = "♖"
            static let whiteBishop = "♗"
            static let whiteKnight = "♘"
            static let whitePawn = "♙"

            static let blackKing = "♚"
            static let blackQueen = "♛"
            static let blackRook = "♜"
            static let blackBishop = "♝"
            static let blackKnight = "♞"
            static let blackPawn = "♟"
        }
    }

    enum PieceValues {
        static let king = 1000
        static let queen = 9
        static let rook = 5
        static let bishopOrKnight = 3
        static let pawn = 1
    }

    enum Theme {
        static let navigationBarPrefersLargeTitles = true
    }
}
extension AppConstants {

    enum GameDefaults {
        static let firstMoveNumber = 1
        static let movesPerFullTurn = 2

        static let whiteForwardStep = -1
        static let blackForwardStep = 1

        static let doublePawnMoveDistance = 2
        static let castlingColumnShift = 2
    }

    enum MoveOffsets {
        static let pawnCaptureColumns = [-1, 1]

        static let king: [(Int, Int)] = [
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1),           (0, 1),
            (1, -1),  (1, 0),  (1, 1)
        ]

        static let knight: [(Int, Int)] = [
            (-2, -1), (-2, 1),
            (-1, -2), (-1, 2),
            (1, -2),  (1, 2),
            (2, -1),  (2, 1)
        ]
    }

    enum MoveDirections {
        static let rook: [(Int, Int)] = [
            (1, 0), (-1, 0), (0, 1), (0, -1)
        ]

        static let bishop: [(Int, Int)] = [
            (1, 1), (1, -1), (-1, 1), (-1, -1)
        ]

        static let queen: [(Int, Int)] = [
            (1, 0), (-1, 0), (0, 1), (0, -1),
            (1, 1), (1, -1), (-1, 1), (-1, -1)
        ]
    }


}
