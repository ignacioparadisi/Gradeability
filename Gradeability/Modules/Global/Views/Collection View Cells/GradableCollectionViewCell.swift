//
//  GradableCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradableCollectionViewCell: UICollectionViewCell, ReusableView {
    private let primaryCellView: GradableCellPrimaryView = GradableCellPrimaryView()
    private let secondaryCellView = GradableCellSecondaryView()
    private var currentLocation: CGPoint = CGPoint(x: 0, y: 0)
    private var primaryViewBottomAnchor: Anchor?
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.cornerRadius = Constants.cornerRadius
        contentView.backgroundColor = UIColor(named: "cellSecondaryBackgroundColor")
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.addSubview(primaryCellView)
        primaryCellView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        primaryViewBottomAnchor = primaryCellView.anchor.bottomToSuperview()
        setupSecondaryView()
    }
    
    private func setupSecondaryView() {
        contentView.addSubview(secondaryCellView)
        secondaryCellView.anchor
            .top(to: primaryCellView.bottomAnchor)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    func configure(with viewModel: GradableCellViewModelRepresentable) {
        primaryCellView.configure(with: viewModel.primaryViewModel)
        if viewModel.shouldShowSecondaryView {
            primaryViewBottomAnchor?.deactivate()
            setupSecondaryView()
            secondaryCellView.configure(with: viewModel.secondaryViewTitle ?? "", progress: viewModel.secondaryViewProgress ?? 0.0, progressText: viewModel.secondaryViewProgressText ?? "")
            contentView.addShadow(height: 6)
        } else {
            removeShadow()
            primaryViewBottomAnchor?.activate()
            secondaryCellView.removeFromSuperview()
        }
    }
}


