//
//  RulesContracts.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

protocol RulesViewProtocol: AnyObject {
    func showTitle(_ text: String)
    func showRules(_ text: String)
}

protocol RulesPresenterProtocol: AnyObject {
    func viewDidLoad()
}

protocol RulesInteractorProtocol: AnyObject {
    func makeRulesText() -> String
}

protocol RulesRouterProtocol: AnyObject {
}
