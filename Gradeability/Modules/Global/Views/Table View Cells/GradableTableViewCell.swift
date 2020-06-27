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
    private let textContainerView = UIView()
    private let containerView = UIView()
    private let progressContainerView = UIView()
    private let progressView = UIProgressView()

    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(progressContainerView)
        progressContainerView.addSubview(containerView)
        containerView.addSubview(textContainerView)
        containerView.addSubview(gradeRingView)
        setupProgressContainerView()
        setupTextContainerView()
        setupGradeRingView()
    }
    
    private func setupProgressContainerView() {
        progressContainerView.backgroundColor = .systemGray5
        progressContainerView.layer.cornerRadius = 20
        progressContainerView.anchor
            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 20, bottom: -8, right: -20))
            .activate()
        
        setupContainerView()
        
        let progressTitleLabel = UILabel()
        progressTitleLabel.text = "Porcentaje evaluado".uppercased()
        progressTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        let percentageLabel = UILabel()
        percentageLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        percentageLabel.text = "30%"
        progressView.backgroundColor = .systemGray3
        progressView.progressViewStyle = .bar
        progressView.progress = 0.3
        progressContainerView.addSubview(progressTitleLabel)
        progressContainerView.addSubview(progressView)
        progressContainerView.addSubview(percentageLabel)

        progressTitleLabel.anchor
            .top(to: containerView.bottomAnchor, constant: 8)
            .trailingToSuperview(constant: -20)
            .leadingToSuperview(constant: 20)
            .activate()

        progressView.anchor
            .top(to: progressTitleLabel.bottomAnchor, constant: 5)
            .trailing(to: progressTitleLabel.trailingAnchor)
            .leading(to: progressTitleLabel.leadingAnchor)
            .activate()

        percentageLabel.anchor
            .top(to: progressView.bottomAnchor, constant: 3)
            .trailing(to: progressTitleLabel.trailingAnchor)
            .bottomToSuperview(constant: -8)
            .leading(to: progressTitleLabel.leadingAnchor)
            .activate()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .secondarySystemGroupedBackground
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.2
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = false
        containerView.anchor
            .topToSuperview()
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
    }
    
    private func setupTextContainerView() {
        textContainerView.anchor
            .top(to: containerView.topAnchor, constant: 15)
            .bottom(to: containerView.bottomAnchor, constant: -15)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .centerYToSuperview()
            .activate()
        
        textContainerView.addSubview(nameLabel)
        textContainerView.addSubview(detailLabel)
        setupNameLabel()
        setupDetailLabel()
    }
    
    private func setupGradeRingView() {
        gradeRingView.anchor
            .top(greaterOrEqual: containerView.topAnchor)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .bottom(lessOrEqual: containerView.bottomAnchor)
            .leading(to: textContainerView.trailingAnchor, constant: 10)
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
        // accessoryType = viewModel.accessoryType
        nameLabel.text = viewModel.name
        detailLabel.text = "􀉭 \(viewModel.detail)"
        gradeRingView.configure(with: viewModel.gradeRingViewModel)
        layoutIfNeeded()
    }
    
}
