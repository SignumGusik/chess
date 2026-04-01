//
//  RulesPresenter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

final class RulesPresenter: RulesPresenterProtocol {

    weak var view: RulesViewProtocol?
    private let interactor: RulesInteractorProtocol

    init(view: RulesViewProtocol, interactor: RulesInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }

    func viewDidLoad() {
        view?.showTitle("Правила")
        view?.showRules(interactor.makeRulesText())
    }
}
