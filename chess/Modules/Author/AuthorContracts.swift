//
//  AuthorContracts.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

protocol AuthorViewProtocol: AnyObject {
    func showAuthorInfo(_ viewModel: AuthorViewModel)
}

protocol AuthorPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapTelegram()
    func didTapGitHub()
}

protocol AuthorInteractorProtocol: AnyObject {
    func makeAuthorViewModel() -> AuthorViewModel
}

protocol AuthorRouterProtocol: AnyObject {
    func openURL(_ url: URL)
}
