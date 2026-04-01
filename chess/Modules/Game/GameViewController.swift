//
//  GameViewController.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class GameViewController: UIViewController, GameViewProtocol {

    var presenter: GamePresenterProtocol?

    private var boardCells: [BoardCellViewModel] = []
    private var moveHistory: [String] = []

    private let infoContainerView = UIView()
    private let statusLabel = UILabel()
    private let moveCounterLabel = UILabel()

    private let boardContainerView = UIView()
    private let boardCollectionView: UICollectionView

    private let historyContainerView = UIView()
    private let historyTitleLabel = UILabel()
    private let historyTextView = UITextView()

    private let pauseButton = UIButton(type: .system)
    private let newGameButton = UIButton(type: .system)
    private let undoButton = UIButton(type: .system)
    private let abilityButton = UIButton(type: .system)

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = AppConstants.Layout.zero
        layout.minimumInteritemSpacing = AppConstants.Layout.zero
        layout.sectionInset = .zero
        layout.estimatedItemSize = .zero
        boardCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                title: AppConstants.Strings.Start.rules,
                style: .plain,
                target: self,
                action: #selector(didTapRules)
            ),
            UIBarButtonItem(
                title: AppConstants.Strings.Start.author,
                style: .plain,
                target: self,
                action: #selector(didTapAuthor)
            )
        ]

        presenter?.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBoardLayout()
    }

    func showGameState(_ state: GameStateViewModel) {
        boardCells = state.boardCells

        if let statusText = state.statusText {
            statusLabel.textColor = .systemRed
            statusLabel.text = "\(state.currentTurnText)\n\(statusText)"
        } else {
            statusLabel.textColor = .label
            statusLabel.text = state.currentTurnText
        }

        moveCounterLabel.text = state.moveCounterText

        historyTextView.text = state.moveHistory.isEmpty
            ? AppConstants.Strings.Game.noMovesYet
            : formattedMoveHistory(state.moveHistory)

        boardCollectionView.reloadData()
        updateBoardLayout()
    }

    func showAvailableMoves(_ positions: [BoardPosition]) {
        boardCells = boardCells.map { cell in
            BoardCellViewModel(
                position: cell.position,
                pieceText: cell.pieceText,
                pieceColor: cell.pieceColor,
                isHighlighted: positions.contains(cell.position),
                isSelected: cell.isSelected,
                isCheck: cell.isCheck
            )
        }
        boardCollectionView.reloadData()
    }

    func hideAvailableMoves() {
        boardCells = boardCells.map { cell in
            BoardCellViewModel(
                position: cell.position,
                pieceText: cell.pieceText,
                pieceColor: cell.pieceColor,
                isHighlighted: false,
                isSelected: cell.isSelected,
                isCheck: cell.isCheck
            )
        }
        boardCollectionView.reloadData()
    }

    func showCheck(for color: PieceColor) {
        statusLabel.textColor = .systemRed
        statusLabel.text = AppConstants.Strings.Game.checkPrefix + color.title
    }

    func showCheckmate(winner: PieceColor) {
        statusLabel.textColor = .systemRed
        statusLabel.text = AppConstants.Strings.Game.checkmatePrefix + winner.title

        let alert = UIAlertController(
            title: AppConstants.Strings.Game.gameFinishedTitle,
            message: AppConstants.Strings.Game.checkmatePrefix + winner.title,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: AppConstants.Strings.Start.newGame, style: .default) { [weak self] _ in
                self?.presenter?.didTapNewGame()
            }
        )
        alert.addAction(UIAlertAction(title: AppConstants.Strings.Common.ok, style: .cancel))

        present(alert, animated: true)
    }

    func showStalemate() {
        statusLabel.textColor = .systemRed
        statusLabel.text = AppConstants.Strings.Game.stalemate

        let alert = UIAlertController(
            title: AppConstants.Strings.Game.gameFinishedTitle,
            message: AppConstants.Strings.Game.stalemate,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: AppConstants.Strings.Common.ok, style: .default))
        present(alert, animated: true)
    }

    func showPromotionOptions(for color: PieceColor) {
        let alert = UIAlertController(
            title: AppConstants.Strings.Game.promotionTitle,
            message: "\(color.title) \(AppConstants.Strings.Game.promotionMessagePrefix)",
            preferredStyle: .actionSheet
        )

        let availablePromotions: [PieceType] = [.queen, .rook, .bishop, .knight]

        for pieceType in availablePromotions {
            alert.addAction(
                UIAlertAction(title: pieceType.title, style: .default) { [weak self] _ in
                    self?.presenter?.didSelectPromotionPiece(pieceType)
                }
            )
        }

        alert.addAction(UIAlertAction(title: AppConstants.Strings.Common.cancel, style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 1, height: 1)
        }

        present(alert, animated: true)
    }

    func showMessage(_ text: String) {
        let alert = UIAlertController(
            title: nil,
            message: text,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AppConstants.Strings.Common.ok, style: .default))
        present(alert, animated: true)
    }

    func updateMoveHistory(_ moves: [String]) {
        moveHistory = moves
        historyTextView.text = moves.isEmpty
            ? AppConstants.Strings.Game.noMovesYet
            : formattedMoveHistory(moves)
    }

    func setPauseState(isPaused: Bool) {
        view.alpha = isPaused ? AppConstants.Layout.alphaPaused : 1.0
    }

    func showRocketAnimation(at position: BoardPosition, completion: @escaping () -> Void) {
        guard let index = BoardCoordinateConverter.positionToIndex(position) else {
            completion()
            return
        }

        let indexPath = IndexPath(item: index, section: AppConstants.Layout.zeroInt)

        guard let cell = boardCollectionView.cellForItem(at: indexPath) else {
            completion()
            return
        }

        let rocketView = UIView()
        rocketView.translatesAutoresizingMaskIntoConstraints = true
        rocketView.frame = CGRect(
            x: view.bounds.midX - AppConstants.Animation.rocketWidth / 2,
            y: AppConstants.Animation.rocketStartYOffset,
            width: AppConstants.Animation.rocketWidth,
            height: AppConstants.Animation.rocketHeight
        )
        rocketView.backgroundColor = .systemRed
        rocketView.layer.cornerRadius = AppConstants.Layout.cornerRadius8

        view.addSubview(rocketView)

        let targetFrame = cell.convert(cell.bounds, to: view)

        UIView.animate(withDuration: AppConstants.Animation.rocketFlyDuration, animations: {
            rocketView.center = CGPoint(x: targetFrame.midX, y: targetFrame.midY)
        }, completion: { _ in
            UIView.animate(withDuration: AppConstants.Animation.rocketImpactPhaseDuration, animations: {
                cell.contentView.transform = CGAffineTransform(
                    scaleX: AppConstants.Animation.rocketImpactScale,
                    y: AppConstants.Animation.rocketImpactScale
                )
                cell.contentView.backgroundColor = .systemRed.withAlphaComponent(AppConstants.Animation.rocketImpactAlpha)
            }, completion: { _ in
                UIView.animate(withDuration: AppConstants.Animation.rocketImpactPhaseDuration, animations: {
                    cell.contentView.transform = .identity
                }, completion: { _ in
                    rocketView.removeFromSuperview()
                    completion()
                })
            })
        })
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = AppConstants.App.appTitle

        setupInfoPanel()
        setupBoard()
        setupHistory()
        setupControls()
        buildLayout()
    }

    private func setupInfoPanel() {
        infoContainerView.translatesAutoresizingMaskIntoConstraints = false
        infoContainerView.backgroundColor = .secondarySystemBackground
        infoContainerView.layer.cornerRadius = AppConstants.Layout.cornerRadius18
        infoContainerView.layer.shadowColor = UIColor.black.cgColor
        infoContainerView.layer.shadowOpacity = AppConstants.Layout.infoShadowOpacity
        infoContainerView.layer.shadowOffset = CGSize(
            width: AppConstants.Layout.zero,
            height: AppConstants.Layout.tiny3
        )
        infoContainerView.layer.shadowRadius = AppConstants.Layout.infoShadowRadius
        infoContainerView.layer.masksToBounds = false

        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.gameStatus, weight: .bold)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = AppConstants.Layout.multiLine

        moveCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        moveCounterLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.gameMoveCounter, weight: .medium)
        moveCounterLabel.textAlignment = .center
        moveCounterLabel.textColor = .secondaryLabel
    }

    private func setupBoard() {
        boardContainerView.translatesAutoresizingMaskIntoConstraints = false
        boardContainerView.backgroundColor = .secondarySystemBackground
        boardContainerView.layer.cornerRadius = AppConstants.Layout.cornerRadius18
        boardContainerView.layer.shadowColor = UIColor.black.cgColor
        boardContainerView.layer.shadowOpacity = AppConstants.Layout.boardShadowOpacity
        boardContainerView.layer.shadowOffset = CGSize(
            width: AppConstants.Layout.zero,
            height: AppConstants.Layout.boardShadowOffset
        )
        boardContainerView.layer.shadowRadius = AppConstants.Layout.boardShadowRadius
        boardContainerView.layer.masksToBounds = false

        boardCollectionView.translatesAutoresizingMaskIntoConstraints = false
        boardCollectionView.backgroundColor = .clear
        boardCollectionView.dataSource = self
        boardCollectionView.delegate = self
        boardCollectionView.register(BoardCell.self, forCellWithReuseIdentifier: BoardCell.reuseIdentifier)
        boardCollectionView.layer.cornerRadius = AppConstants.Layout.cornerRadius14
        boardCollectionView.layer.borderWidth = AppConstants.Layout.boardBorderWidth
        boardCollectionView.layer.borderColor = UIColor.boardBorder.cgColor
        boardCollectionView.clipsToBounds = true
        boardCollectionView.contentInset = .zero
        boardCollectionView.scrollIndicatorInsets = .zero
        boardCollectionView.showsVerticalScrollIndicator = false
        boardCollectionView.showsHorizontalScrollIndicator = false
        boardCollectionView.isScrollEnabled = false
    }

    private func setupHistory() {
        historyContainerView.translatesAutoresizingMaskIntoConstraints = false
        historyContainerView.backgroundColor = .secondarySystemBackground
        historyContainerView.layer.cornerRadius = AppConstants.Layout.cornerRadius18

        historyTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        historyTitleLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.gameHistoryTitle, weight: .bold)
        historyTitleLabel.text = AppConstants.Strings.Game.historyTitle

        historyTextView.translatesAutoresizingMaskIntoConstraints = false
        historyTextView.isEditable = false
        historyTextView.font = UIFont.monospacedSystemFont(ofSize: AppConstants.Fonts.gameHistoryText, weight: .regular)
        historyTextView.backgroundColor = .tertiarySystemBackground
        historyTextView.layer.cornerRadius = AppConstants.Layout.cornerRadius12
        historyTextView.textContainerInset = UIEdgeInsets(
            top: AppConstants.Layout.small10,
            left: AppConstants.Layout.small10,
            bottom: AppConstants.Layout.small10,
            right: AppConstants.Layout.small10
        )
        historyTextView.showsVerticalScrollIndicator = false
        historyTextView.showsHorizontalScrollIndicator = false
    }

    private func setupControls() {
        configureSecondaryControlButton(pauseButton, title: AppConstants.Strings.Game.pause)
        configurePrimaryControlButton(newGameButton, title: AppConstants.Strings.Start.newGame)
        configureSecondaryControlButton(undoButton, title: AppConstants.Strings.Game.undo)
        configureSecondaryControlButton(abilityButton, title: AppConstants.Strings.Game.superPower)

        pauseButton.addTarget(self, action: #selector(didTapPause), for: .touchUpInside)
        newGameButton.addTarget(self, action: #selector(didTapNewGame), for: .touchUpInside)
        undoButton.addTarget(self, action: #selector(didTapUndo), for: .touchUpInside)
        abilityButton.addTarget(self, action: #selector(didTapUseAbility), for: .touchUpInside)
    }

    private func buildLayout() {
        let infoStack = UIStackView(arrangedSubviews: [
            statusLabel,
            moveCounterLabel
        ])
        infoStack.axis = .vertical
        infoStack.spacing = AppConstants.Layout.tiny4

        infoStack.addTo(infoContainerView)

        let controlsStack = UIStackView(arrangedSubviews: [
            pauseButton,
            newGameButton,
            undoButton,
            abilityButton
        ])
        controlsStack.axis = .horizontal
        controlsStack.spacing = AppConstants.Layout.small8
        controlsStack.distribution = .fillEqually

        boardCollectionView.addTo(boardContainerView)
        historyTitleLabel.addTo(historyContainerView)
        historyTextView.addTo(historyContainerView)

        infoContainerView.addTo(view)
        boardContainerView.addTo(view)
        controlsStack.addTo(view)
        historyContainerView.addTo(view)

        infoContainerView
            .pinTop(toAnchor: view.safeAreaLayoutGuide.topAnchor, constant: AppConstants.Layout.small10)
            .pinLeading(to: view.leadingAnchor, constant: AppConstants.Layout.medium16)
            .pinTrailing(to: view.trailingAnchor, constant: -AppConstants.Layout.medium16)

        infoStack
            .pinTop(toAnchor: infoContainerView.topAnchor, constant: AppConstants.Layout.medium12)
            .pinLeading(to: infoContainerView.leadingAnchor, constant: AppConstants.Layout.medium12)
            .pinTrailing(to: infoContainerView.trailingAnchor, constant: -AppConstants.Layout.medium12)
            .pinBottom(toAnchor: infoContainerView.bottomAnchor, constant: -AppConstants.Layout.medium12)

        boardContainerView
            .pinTop(toAnchor: infoContainerView.bottomAnchor, constant: AppConstants.Layout.small10)
            .pinLeading(to: view.leadingAnchor, constant: AppConstants.Layout.medium16)
            .pinTrailing(to: view.trailingAnchor, constant: -AppConstants.Layout.medium16)

        boardCollectionView
            .pinTop(toAnchor: boardContainerView.topAnchor, constant: AppConstants.Layout.medium12)
            .pinLeading(to: boardContainerView.leadingAnchor, constant: AppConstants.Layout.medium12)
            .pinTrailing(to: boardContainerView.trailingAnchor, constant: -AppConstants.Layout.medium12)
            .pinBottom(toAnchor: boardContainerView.bottomAnchor, constant: -AppConstants.Layout.medium12)

        boardCollectionView.heightAnchor.constraint(equalTo: boardCollectionView.widthAnchor).isActive = true

        controlsStack
            .pinTop(toAnchor: boardContainerView.bottomAnchor, constant: AppConstants.Layout.small10)
            .pinLeading(to: view.leadingAnchor, constant: AppConstants.Layout.medium16)
            .pinTrailing(to: view.trailingAnchor, constant: -AppConstants.Layout.medium16)
            .setHeight(AppConstants.Layout.buttonHeight44)

        historyContainerView
            .pinTop(toAnchor: controlsStack.bottomAnchor, constant: AppConstants.Layout.small10)
            .pinLeading(to: view.leadingAnchor, constant: AppConstants.Layout.medium16)
            .pinTrailing(to: view.trailingAnchor, constant: -AppConstants.Layout.medium16)
            .pinBottom(toAnchor: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Layout.small10)

        historyTitleLabel
            .pinTop(toAnchor: historyContainerView.topAnchor, constant: AppConstants.Layout.medium12)
            .pinLeading(to: historyContainerView.leadingAnchor, constant: AppConstants.Layout.medium12)
            .pinTrailing(to: historyContainerView.trailingAnchor, constant: -AppConstants.Layout.medium12)

        historyTextView
            .pinTop(toAnchor: historyTitleLabel.bottomAnchor, constant: AppConstants.Layout.small8)
            .pinLeading(to: historyContainerView.leadingAnchor, constant: AppConstants.Layout.small10)
            .pinTrailing(to: historyContainerView.trailingAnchor, constant: -AppConstants.Layout.small10)
            .pinBottom(toAnchor: historyContainerView.bottomAnchor, constant: -AppConstants.Layout.small10)
    }

    private func configurePrimaryControlButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = AppConstants.Layout.cornerRadius14
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppConstants.Fonts.gameHistoryText, weight: .bold)
    }

    private func configureSecondaryControlButton(_ button: UIButton, title: String) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = AppConstants.Layout.cornerRadius14
        button.titleLabel?.font = UIFont.systemFont(ofSize: AppConstants.Fonts.gameHistoryText, weight: .semibold)
    }

    private func updateBoardLayout() {
        boardCollectionView.collectionViewLayout.invalidateLayout()
    }

    private func formattedMoveHistory(_ moves: [String]) -> String {
        var result: [String] = []
        var moveNumber = AppConstants.GameDefaults.firstMoveNumber
        var index = AppConstants.Layout.zeroInt

        while index < moves.count {
            let whiteMove = moves[index]
            let blackMove = index + 1 < moves.count ? moves[index + 1] : AppConstants.Strings.Common.empty
            result.append("\(moveNumber). \(whiteMove) \(blackMove)")
            moveNumber += 1
            index += AppConstants.GameDefaults.movesPerFullTurn
        }

        return result.joined(separator: AppConstants.Strings.Common.newLine)
    }


    @objc
    private func didTapPause() {
        presenter?.didTapPause()
    }

    @objc
    private func didTapNewGame() {
        presenter?.didTapNewGame()
    }

    @objc
    private func didTapUndo() {
        presenter?.didTapUndo()
    }

    @objc
    private func didTapUseAbility() {
        presenter?.didTapUseAbility()
    }

    @objc
    private func didTapRules() {
        presenter?.didTapRules()
    }

    @objc
    private func didTapAuthor() {
        presenter?.didTapAuthor()
    }
}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        boardCells.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BoardCell.reuseIdentifier,
                for: indexPath
            ) as? BoardCell
        else {
            return UICollectionViewCell()
        }

        let model = boardCells[indexPath.item]
        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = boardCells[indexPath.item]
        presenter?.didTapCell(at: model.position)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let side = collectionView.bounds.width / CGFloat(AppConstants.Board.size)
        return CGSize(width: side, height: side)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppConstants.Layout.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        AppConstants.Layout.zero
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        .zero
    }
}
