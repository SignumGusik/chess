//
//  StartGameViewController.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class StartGameViewController: UIViewController, StartGameViewProtocol {

    var presenter: StartGamePresenterProtocol?

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    private let whiteAbilityLabel = UILabel()
    private let blackAbilityLabel = UILabel()

    private let newGameButton = UIButton(type: .system)
    private let continueButton = UIButton(type: .system)
    private let rulesButton = UIButton(type: .system)
    private let authorButton = UIButton(type: .system)
    private let themeButton = UIButton(type: .system)

    private let containerView = UIView()
    private let statusContainerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }

    func showTitle(_ text: String) {
        titleLabel.text = text
    }

    func showContinueGame(isEnabled: Bool) {
        continueButton.isEnabled = isEnabled
        continueButton.alpha = isEnabled ? 1.0 : AppConstants.Layout.alphaDisabled
    }

    func showSelectedAbilities(whiteAbility: String?, blackAbility: String?) {
        whiteAbilityLabel.text = whiteAbility == nil
            ? AppConstants.Strings.Start.whiteAbilityNotSelected
            : AppConstants.Strings.Start.whiteAbilitySelected

        blackAbilityLabel.text = blackAbility == nil
            ? AppConstants.Strings.Start.blackAbilityNotSelected
            : AppConstants.Strings.Start.blackAbilitySelected
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = AppConstants.App.startTitle

        setupContainer()
        setupLabels()
        setupButtons()
        buildLayout()
    }

    private func setupContainer() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .secondarySystemBackground
        containerView.layer.cornerRadius = AppConstants.Layout.cornerRadius24
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = AppConstants.Layout.startContainerShadowOpacity
        containerView.layer.shadowOffset = CGSize(
            width: AppConstants.Layout.zero,
            height: AppConstants.Layout.small8
        )
        containerView.layer.shadowRadius = AppConstants.Layout.large20

        statusContainerView.translatesAutoresizingMaskIntoConstraints = false
        statusContainerView.backgroundColor = .tertiarySystemBackground
        statusContainerView.layer.cornerRadius = AppConstants.Layout.cornerRadius18
    }

    private func setupLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startTitle, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startSubtitle, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = AppConstants.Layout.multiLine
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.text = AppConstants.Strings.Start.subtitle

        whiteAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        whiteAbilityLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startAbility, weight: .semibold)
        whiteAbilityLabel.textAlignment = .center
        whiteAbilityLabel.numberOfLines = AppConstants.Layout.multiLine
        whiteAbilityLabel.textColor = .label

        blackAbilityLabel.translatesAutoresizingMaskIntoConstraints = false
        blackAbilityLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startAbility, weight: .semibold)
        blackAbilityLabel.textAlignment = .center
        blackAbilityLabel.numberOfLines = AppConstants.Layout.multiLine
        blackAbilityLabel.textColor = .label
    }

    private func setupButtons() {
        configurePrimaryButton(newGameButton, title: AppConstants.Strings.Start.newGame)
        configureSecondaryButton(continueButton, title: AppConstants.Strings.Start.continueGame)
        configureSecondaryButton(rulesButton, title: AppConstants.Strings.Start.rules)
        configureSecondaryButton(authorButton, title: AppConstants.Strings.Start.author)
        configureSecondaryButton(themeButton, title: AppConstants.Strings.Start.changeTheme)

        newGameButton.addTarget(self, action: #selector(didTapNewGame), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(didTapContinueGame), for: .touchUpInside)
        rulesButton.addTarget(self, action: #selector(didTapRules), for: .touchUpInside)
        authorButton.addTarget(self, action: #selector(didTapAuthor), for: .touchUpInside)
        themeButton.addTarget(self, action: #selector(didTapTheme), for: .touchUpInside)
    }

    private func buildLayout() {
        let statusStack = UIStackView(arrangedSubviews: [
            whiteAbilityLabel,
            blackAbilityLabel
        ])
        statusStack.axis = .vertical
        statusStack.spacing = AppConstants.Layout.small10

        statusStack
            .addTo(statusContainerView)
            .pinTop(toAnchor: statusContainerView.topAnchor, constant: AppConstants.Layout.medium14)
            .pinLeading(to: statusContainerView.leadingAnchor, constant: AppConstants.Layout.medium14)
            .pinTrailing(to: statusContainerView.trailingAnchor, constant: -AppConstants.Layout.medium14)
            .pinBottom(toAnchor: statusContainerView.bottomAnchor, constant: -AppConstants.Layout.medium14)

        let buttonsStack = UIStackView(arrangedSubviews: [
            newGameButton,
            continueButton,
            rulesButton,
            authorButton,
            themeButton
        ])
        buttonsStack.axis = .vertical
        buttonsStack.spacing = AppConstants.Layout.medium14

        let contentStack = UIStackView(arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            statusContainerView,
            buttonsStack
        ])
        contentStack.axis = .vertical
        contentStack.spacing = AppConstants.Layout.medium18

        containerView.addTo(view)
        contentStack.addTo(containerView)

        containerView
            .centerYOn(view)
            .pinHorizontal(to: view, inset: AppConstants.Layout.large20)

        contentStack
            .pinTop(toAnchor: containerView.topAnchor, constant: AppConstants.Layout.xLarge26)
            .pinLeading(to: containerView.leadingAnchor, constant: AppConstants.Layout.large20)
            .pinTrailing(to: containerView.trailingAnchor, constant: -AppConstants.Layout.large20)
            .pinBottom(toAnchor: containerView.bottomAnchor, constant: -AppConstants.Layout.xLarge26)

        newGameButton.setHeight(AppConstants.Layout.buttonHeight50)
        continueButton.setHeight(AppConstants.Layout.buttonHeight50)
        rulesButton.setHeight(AppConstants.Layout.buttonHeight48)
        authorButton.setHeight(AppConstants.Layout.buttonHeight48)
        themeButton.setHeight(AppConstants.Layout.buttonHeight48)
    }

    private func configurePrimaryButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startPrimaryButton, weight: .bold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = AppConstants.Layout.cornerRadius16
    }

    private func configureSecondaryButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppConstants.Fonts.startSecondaryButton, weight: .semibold)
        button.backgroundColor = .tertiarySystemBackground
        button.layer.cornerRadius = AppConstants.Layout.cornerRadius16
    }

    @objc
    private func didTapNewGame() {
        presenter?.didTapNewGame()
    }

    @objc
    private func didTapContinueGame() {
        presenter?.didTapContinueGame()
    }

    @objc
    private func didTapRules() {
        presenter?.didTapRules()
    }

    @objc
    private func didTapAuthor() {
        presenter?.didTapAuthor()
    }

    @objc
    private func didTapTheme() {
        presenter?.didTapTheme()
    }
}
