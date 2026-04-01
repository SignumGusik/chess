//
//  AuthorPresenter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

final class AuthorPresenter: AuthorPresenterProtocol {

    weak var view: AuthorViewProtocol?

    private let interactor: AuthorInteractorProtocol
    private let router: AuthorRouterProtocol

    private var viewModel: AuthorViewModel?

    init(
        view: AuthorViewProtocol,
        interactor: AuthorInteractorProtocol,
        router: AuthorRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        let model = interactor.makeAuthorViewModel()
        viewModel = model
        view?.showAuthorInfo(model)
    }

    func didTapTelegram() {
        guard let url = viewModel?.telegramURL else {
            return
        }
        router.openURL(url)
    }

    func didTapGitHub() {
        guard let url = viewModel?.gitHubURL else {
            return
        }
        router.openURL(url)
    }
}
