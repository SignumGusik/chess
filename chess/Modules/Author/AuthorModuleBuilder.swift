//
//  AuthorModuleBuilder.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

enum AuthorModuleBuilder {
    static func build() -> UIViewController {
        let view = AuthorViewController()
        let interactor = AuthorInteractor()
        let router = AuthorRouter()
        let presenter = AuthorPresenter(
            view: view,
            interactor: interactor,
            router: router
        )

        view.presenter = presenter
        router.viewController = view

        return view
    }
}
