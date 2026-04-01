//
//  AuthorInteractor.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import Foundation

final class AuthorInteractor: AuthorInteractorProtocol {
    func makeAuthorViewModel() -> AuthorViewModel {
        AuthorViewModel(
            name: "Diana Shoshina",
            description: "iOS-приложение шахматы",
            telegramURL: URL(string: "https://t.me/pniha"),
            gitHubURL: URL(string: "https://github.com/SignumGusik/chess.git")
        )
    }
}
