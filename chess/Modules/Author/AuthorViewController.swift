//
//  AuthorViewController.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class AuthorViewController: UIViewController, AuthorViewProtocol {

    var presenter: AuthorPresenterProtocol?

    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let telegramButton = UIButton(type: .system)
    private let gitHubButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    func showAuthorInfo(_ viewModel: AuthorViewModel) {
        title = "Об авторе"
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        telegramButton.isHidden = viewModel.telegramURL == nil
        gitHubButton.isHidden = viewModel.gitHubURL == nil
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground

        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0

        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0

        telegramButton.setTitle("Telegram: @pniha", for: .normal)
        gitHubButton.setTitle("GitHub: SignumGusik", for: .normal)

        telegramButton.addTarget(self, action: #selector(didTapTelegram), for: .touchUpInside)
        gitHubButton.addTarget(self, action: #selector(didTapGitHub), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [
            nameLabel,
            descriptionLabel,
            telegramButton,
            gitHubButton
        ])
        stack.axis = .vertical
        stack.spacing = 20

        stack
            .addTo(view)
            .centerYOn(view)
            .pinHorizontal(to: view, inset: 24)
    }

    @objc
    private func didTapTelegram() {
        presenter?.didTapTelegram()
    }

    @objc
    private func didTapGitHub() {
        presenter?.didTapGitHub()
    }
}
