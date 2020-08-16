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
        backgroundColor = UIColor(named: "cellSecondaryBackgroundColor")
        layer.cornerRadius = 15
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
//        let primaryAssignmentViewModel = AssignmentCellPrimaryViewModel(name: viewModel.name, detail: viewModel.detail, accentText: viewModel.accentText, systemImage: "person.crop.circle", gradeRingViewModel: viewModel.gradeRingViewModel, isFinished: false, position: .middle)
//        let primaryViewModel = GradableCellPrimaryViewModel(name: viewModel.name, detail: viewModel.detail, accentText: viewModel.accentText, systemImage: "person.crop.circle", gradeRingViewModel: viewModel.gradeRingViewModel)
        primaryCellView.configure(with: viewModel.primaryViewModel)
        if viewModel.shouldShowSecondaryView {
            addShadow(height: 6)
            primaryViewBottomAnchor?.deactivate()
            setupSecondaryView()
            secondaryCellView.configure(with: viewModel.secondaryViewTitle ?? "", progress: viewModel.secondaryViewProgress ?? 0.0, progressText: viewModel.secondaryViewProgressText ?? "")
        } else {
            removeShadow()
            primaryViewBottomAnchor?.activate()
            secondaryCellView.removeFromSuperview()
        }
    }
    
}

class AssignmentCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let primaryCellView = AssignmentCellPrimaryView()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.cornerRadius = 15
        contentView.addSubview(primaryCellView)
        primaryCellView.anchor
            .edgesToSuperview()
            .activate()
    }
    
    func configure(with viewModel: GradableCellViewModelRepresentable, position: AssignmentCellPrimaryViewModel.CellPosition) {
        primaryCellView.configure(with: viewModel.primaryViewModel as! AssignmentCellPrimaryViewModel, position: position)
    }
    
}

