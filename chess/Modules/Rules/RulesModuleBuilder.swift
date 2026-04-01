//
//  RulesModuleBuilder.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum RulesModuleBuilder {
    static func build() -> UIViewController {
        let view = RulesViewController()
        let interactor = RulesInteractor()
        let router = RulesRouter()
        let presenter = RulesPresenter(
            view: view,
            interactor: interactor
        )

        view.presenter = presenter
        _ = router

        return view
    }
}
