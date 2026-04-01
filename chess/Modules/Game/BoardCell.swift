//
//  BoardCell.swift
//  chess
//
//  Created by Диана on 31/03/2026.
//

import UIKit

final class BoardCell: UICollectionViewCell {

    static let reuseIdentifier = AppConstants.Strings.Board.cellReuseIdentifier

    private let highlightView = UIView()
    private let pieceLabel = UILabel()
    private let coordinateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pieceLabel.text = nil
        coordinateLabel.text = nil
        highlightView.backgroundColor = .clear
        contentView.transform = .identity
    }

    func configure(with viewModel: BoardCellViewModel) {
        let isLightSquare = (viewModel.position.row + viewModel.position.column)
            .isMultiple(of: AppConstants.Board.squareColorParityDivider)

        contentView.backgroundColor = isLightSquare ? .boardLight : .boardDark
        pieceLabel.text = viewModel.pieceText
        pieceLabel.textColor = viewModel.pieceColor == .white ? .white : .black

        coordinateLabel.text = coordinateText(for: viewModel.position)
        coordinateLabel.textColor = isLightSquare
            ? UIColor.black.withAlphaComponent(AppConstants.Layout.boardCoordinateLightAlpha)
            : UIColor.white.withAlphaComponent(AppConstants.Layout.boardCoordinateDarkAlpha)

        if viewModel.isCheck {
            highlightView.backgroundColor = .boardCheck
        } else if viewModel.isSelected {
            highlightView.backgroundColor = .boardSelected
        } else if viewModel.isHighlighted {
            highlightView.backgroundColor = .boardHighlighted
        } else {
            highlightView.backgroundColor = .clear
        }
    }

    private func coordinateText(for position: BoardPosition) -> String? {
        if position.row == AppConstants.Board.whiteBackRankRow {
            let scalarValue = AppConstants.Board.notationFileBase + UInt32(position.column)
            let fileScalar = UnicodeScalar(scalarValue) ?? UnicodeScalar(AppConstants.Board.notationFileBase)!
            return String(Character(fileScalar))
        }

        if position.column == AppConstants.Board.firstColumn {
            return String(AppConstants.Board.rankMax - position.row)
        }

        return nil
    }

    private func setupUI() {
        contentView.clipsToBounds = true

        highlightView.isUserInteractionEnabled = false

        pieceLabel.textAlignment = .center
        pieceLabel.adjustsFontSizeToFitWidth = true
        pieceLabel.minimumScaleFactor = AppConstants.Layout.boardPieceMinScale
        pieceLabel.font = UIFont.systemFont(ofSize: AppConstants.Fonts.boardPiece)

        coordinateLabel.font = UIFont.systemFont(
            ofSize: AppConstants.Fonts.boardCoordinate,
            weight: .bold
        )
        coordinateLabel.textAlignment = .left

        highlightView
            .addTo(contentView)
            .pinTop(toAnchor: contentView.topAnchor)
            .pinLeading(to: contentView.leadingAnchor)
            .pinTrailing(to: contentView.trailingAnchor)
            .pinBottom(toAnchor: contentView.bottomAnchor)

        pieceLabel
            .addTo(contentView)
            .centerOn(contentView)

        coordinateLabel
            .addTo(contentView)
            .pinLeading(to: contentView.leadingAnchor, constant: AppConstants.Layout.tiny2)
            .pinBottom(toAnchor: contentView.bottomAnchor, constant: -AppConstants.Layout.tiny2)
    }
}
