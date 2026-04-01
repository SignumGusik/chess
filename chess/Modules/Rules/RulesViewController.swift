//
//  RulesViewController.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class RulesViewController: UIViewController, RulesViewProtocol {

    var presenter: RulesPresenterProtocol?

    private let textView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    func showTitle(_ text: String) {
        title = text
    }

    func showRules(_ text: String) {
        textView.text = text
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        textView.addTo(view)
        textView
            .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor, constant: 16)
            .pinLeading(to: view.leadingAnchor, constant: 16)
            .pinTrailing(to: view.trailingAnchor, constant: -16)
            .pinBottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
    }
}
