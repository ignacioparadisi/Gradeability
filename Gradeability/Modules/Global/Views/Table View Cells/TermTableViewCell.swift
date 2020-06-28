//
//  TermTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

//class TermTableViewCell: UITableViewCell, ReusableView {
//    
//    private let gradeRingView = GradeRingView(radius: 22)
//    private let nameLabel = UILabel()
//    private let detailLabel = UILabel()
//    private let textContainerView = UIView()
//    private let containerView = UIView()
//    private let progressContainerView = UIView()
//    private let progressView = UIProgressView()
//    private let progressContentContainerView = UIView()
//    private var containerViewBottomAnchor: Anchor?
//    private let currentTermLabel = UILabel()
//    private var nameTopAnchor: NSLayoutConstraint?
//
//    // MARK: Initializers
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupView() {
//        backgroundColor = .clear
//        contentView.addSubview(progressContainerView)
//        setupProgressContainerView()
//        progressContainerView.addSubview(containerView)
//        containerView.addSubview(textContainerView)
//        containerView.addSubview(gradeRingView)
//        setupContainerView()
//        setupTextContainerView()
//        setupGradeRingView()
//    }
//    
//    func addBlurView() {
//        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        blurView.layer.cornerRadius = 20
//        blurView.clipsToBounds = true
//        progressContainerView.addSubview(blurView)
//        blurView.anchor.edgesToSuperview().activate()
//    }
//    
//    private func setupProgressView() {
//        progressContainerView.addSubview(progressContentContainerView)
//        progressContentContainerView.anchor
//            .top(to: containerView.bottomAnchor, constant: 8)
//            .trailingToSuperview(constant: -20)
//            .leadingToSuperview(constant: 20)
//            .bottomToSuperview(constant: -8)
//            .activate()
//        
//        let progressTitleLabel = UILabel()
//        progressTitleLabel.text = "Días restantes".uppercased()
//        progressTitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold
//        let percentageLabel = UILabel()
//        percentageLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//        percentageLabel.text = "300 días"
//        progressView.backgroundColor = .systemGray3
//        progressView.progressViewStyle = .bar
//        progressView.progress = 0.3
//        
//        progressContentContainerView.addSubview(progressTitleLabel)
//        progressContentContainerView.addSubview(progressView)
//        progressContentContainerView.addSubview(percentageLabel)
//        
//        progressTitleLabel.anchor
//            .topToSuperview()
//            .trailingToSuperview()
//            .leadingToSuperview()
//            .activate()
//
//        progressView.anchor
//            .top(to: progressTitleLabel.bottomAnchor, constant: 5)
//            .trailingToSuperview()
//            .leadingToSuperview()
//            .activate()
//
//        percentageLabel.anchor
//            .top(to: progressView.bottomAnchor, constant: 3)
//            .trailingToSuperview()
//            .bottomToSuperview()
//            .leadingToSuperview()
//            .activate()
//    }
//    
//    private func setupProgressContainerView() {
//        progressContainerView.backgroundColor = .tertiarySystemBackground
//        progressContainerView.layer.cornerRadius = 20
//        progressContainerView.anchor
//            .edgesToSuperview(insets: UIEdgeInsets(top: 8, left: 20, bottom: -8, right: -20))
//            .activate()
//        addBlurView()
//    }
//    
//    private func setupContainerView() {
//        containerView.backgroundColor = .secondarySystemGroupedBackground
//        containerView.layer.shadowColor = UIColor.black.cgColor
//        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        containerView.layer.shadowRadius = 6
//        containerView.layer.shadowOpacity = 0.2
//        containerView.layer.cornerRadius = 20
//        containerView.clipsToBounds = false
//        containerView.anchor
//            .topToSuperview()
//            .leadingToSuperview()
//            .trailingToSuperview()
//            .activate()
//        
//        containerViewBottomAnchor = containerView.anchor.bottomToSuperview()
//    }
//    
//    private func setupTextContainerView() {
//        textContainerView.anchor
//            .top(to: containerView.topAnchor, constant: 15)
//            .bottom(to: containerView.bottomAnchor, constant: -15)
//            .leadingToSuperview(constant: 20, toSafeArea: true)
//            .centerYToSuperview()
//            .activate()
//        
//        textContainerView.addSubview(currentTermLabel)
//        textContainerView.addSubview(nameLabel)
//        textContainerView.addSubview(detailLabel)
//        setupCurrentTermLabel()
//        setupNameLabel()
//        setupDetailLabel()
//    }
//    
//    private func setupGradeRingView() {
//        gradeRingView.anchor
//            .top(greaterOrEqual: containerView.topAnchor)
//            .trailingToSuperview(constant: -20, toSafeArea: true)
//            .bottom(lessOrEqual: containerView.bottomAnchor)
//            .leading(to: textContainerView.trailingAnchor, constant: 10)
//            .centerYToSuperview()
//            .width(constant: 44)
//            .height(constant: 44)
//            .activate()
//    }
//    
//    private func setupNameLabel() {
//        nameLabel.lineBreakMode = .byTruncatingTail
//        nameLabel.numberOfLines = 2
//        nameLabel.anchor
//            .trailingToSuperview()
//            .leadingToSuperview()
//            .activate()
//        
//        nameTopAnchor = nameLabel.topAnchor.constraint(equalTo: currentTermLabel.bottomAnchor)
//        nameTopAnchor?.isActive = true
//    }
//    
//    private func setupDetailLabel() {
//        detailLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
//        detailLabel.textColor = .secondaryLabel
//        detailLabel.anchor
//            .top(to: nameLabel.bottomAnchor, constant: 5)
//            .leadingToSuperview()
//            .trailingToSuperview()
//            .bottomToSuperview()
//            .activate()
//    }
//    
//    private func setupCurrentTermLabel() {
//        currentTermLabel.text = "Período actual".uppercased()
//        currentTermLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold
//        currentTermLabel.textColor = .systemBlue
//        currentTermLabel.anchor
//            .topToSuperview()
//            .leadingToSuperview()
//            .trailingToSuperview()
//            .activate()
//        
//    }
//    
//    func configure(with viewModel: GradableCellViewModelRepresentable) {
//        // accessoryType = viewModel.accessoryType
//        nameLabel.text = viewModel.name
//        detailLabel.text = "􀉭 \(viewModel.detail)"
//        gradeRingView.configure(with: viewModel.gradeRingViewModel)
//        if viewModel.accessoryType == .checkmark {
//            currentTermLabel.isHidden = false
//            currentTermLabel.text = "Período actual".uppercased()
//            nameTopAnchor?.constant = 8
//            containerViewBottomAnchor?.deactivate()
//            setupProgressView()
//        } else {
//            currentTermLabel.isHidden = true
//            currentTermLabel.text = nil
//            nameTopAnchor?.constant = 0
//            progressContentContainerView.removeFromSuperview()
//            containerViewBottomAnchor?.activate()
//        }
//        layoutIfNeeded()
//    }
//    
//}

