//
//  AuthorRouter.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class AuthorRouter: AuthorRouterProtocol {

    weak var viewController: UIViewController?

    func openURL(_ url: URL) {
        UIApplication.shared.open(url)
    }
}
