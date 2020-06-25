//
//  GradableTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradableTableViewCell: UITableViewCell, ReusableView {
    
    private let gradeRingView = GradeRingView(radius: 22)
    private let nameLabel = UILabel()
    private let detailLabel = UILabel()
    private let containerView = UIView()

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(containerView)
        contentView.addSubview(gradeRingView)
        setupContainerView()
        setupGradeRingView()
    }
    
    private func setupContainerView() {
        containerView.anchor
            .top(to: contentView.topAnchor, constant: 8)
            .bottom(to: contentView.bottomAnchor, constant: -8)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .centerYToSuperview()
            .activate()
        
        containerView.addSubview(nameLabel)
        containerView.addSubview(detailLabel)
        setupNameLabel()
        setupDetailLabel()
    }
    
    private func setupGradeRingView() {
        gradeRingView.anchor
            .top(greaterOrEqual: contentView.topAnchor)
            .trailingToSuperview(constant: -10, toSafeArea: true)
            .bottom(lessOrEqual: contentView.bottomAnchor)
            .leading(to: containerView.trailingAnchor, constant: 10)
            .centerYToSuperview()
            .width(constant: 44)
            .height(constant: 44)
            .activate()
    }
    
    private func setupNameLabel() {
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.numberOfLines = 2
        nameLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    private func setupDetailLabel() {
        detailLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        detailLabel.textColor = .secondaryLabel
        detailLabel.anchor
            .top(to: nameLabel.bottomAnchor, constant: 5)
            .leadingToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .activate()
    }
    
    func configure(with viewModel: GradableCellViewModelRepresentable) {
        accessoryType = viewModel.accessoryType
        nameLabel.text = viewModel.name
        detailLabel.text = viewModel.detail
        gradeRingView.configure(with: viewModel.gradeRingViewModel)
        layoutIfNeeded()
    }
    
}
