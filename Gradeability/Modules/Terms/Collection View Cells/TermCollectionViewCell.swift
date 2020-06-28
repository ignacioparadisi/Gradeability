//
//  TermCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

// MARK: Primary View
struct GradableCellPrimaryViewModel: GradableCellPrimaryViewRepresentable {
    var name: String
    var detail: String?
    var accentText: String?
    var systemImage: String?
    var gradeRingViewModel: GradeRingViewModel
    
    init(name: String, detail: String, accentText: String? = nil, systemImage: String? = nil, gradeRingViewModel: GradeRingViewModel) {
        self.name = name
        self.detail = detail
        self.accentText = accentText
        self.systemImage = systemImage
        self.gradeRingViewModel = gradeRingViewModel
    }
}

struct AssignmentCellPrimaryViewModel: GradableCellPrimaryViewRepresentable {
    enum CellPosition {
        case first
        case middle
        case last
    }
    var name: String
    var detail: String?
    var accentText: String?
    var systemImage: String?
    var gradeRingViewModel: GradeRingViewModel
    var isFinished: Bool
    
    init(name: String, detail: String, accentText: String? = nil, systemImage: String? = nil, gradeRingViewModel: GradeRingViewModel, isFinished: Bool) {
        self.name = name
        self.detail = detail
        self.accentText = accentText
        self.systemImage = systemImage
        self.gradeRingViewModel = gradeRingViewModel
        self.isFinished = isFinished
    }
}

protocol GradableCellPrimaryViewRepresentable {
    var name: String { get }
    var detail: String? { get }
    var accentText: String? { get }
    var systemImage: String? { get }
    var gradeRingViewModel: GradeRingViewModel { get }
}

class GradableCellPrimaryView: UIView {
    // MARK: Constant Properties
    private let verticalMargin: CGFloat = 15.0
    private let horizontalMargin: CGFloat = 20.0
    private let ringRadius: CGFloat = 22.0
    
    // MARK: View Properties
    private var gradeRingView: GradeRingView!
    private lazy var iconImageView: UIImageView = UIImageView()
    let contentView: UIView = UIView()
    private let accentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.textColor = .systemBlue
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: Properties
    private var nameLabelTopAnchor: NSLayoutConstraint?
    var contentViewLeadingAnchor: Anchor?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 15
        addShadow()
        setupContentView()
        setupGradeRingView()
    }
    
    private func setupContentView() {
        addSubview(contentView)
        contentView.addSubview(accentLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(detailLabel)
        
        contentView.anchor
            .top(to: topAnchor, constant: verticalMargin)
            .bottom(to: bottomAnchor, constant: -verticalMargin)
            .centerYToSuperview()
            .activate()
        
        contentViewLeadingAnchor = contentView.anchor.leadingToSuperview(constant: horizontalMargin)
        contentViewLeadingAnchor?.activate()
        
        accentLabel.anchor
            .topToSuperview()
            .leadingToSuperview()
            .trailingToSuperview()
            .activate()
        
       nameLabel.anchor
           .trailingToSuperview()
           .leadingToSuperview()
           .activate()
       nameLabelTopAnchor = nameLabel.topAnchor.constraint(equalTo: accentLabel.bottomAnchor)
       nameLabelTopAnchor?.isActive = true
        
        iconImageView.anchor
            .top(to: detailLabel.topAnchor)
            .bottom(to: detailLabel.bottomAnchor)
            .leadingToSuperview()
            .width(to: iconImageView.heightAnchor)
            .activate()
        
        detailLabel.anchor
            .top(to: nameLabel.bottomAnchor, constant: 5)
            .trailingToSuperview()
            .bottomToSuperview()
            .leading(to: iconImageView.trailingAnchor, constant: 3)
            .activate()
    }
    
    private func setupGradeRingView() {
        gradeRingView = GradeRingView(radius: ringRadius)
        addSubview(gradeRingView)
        gradeRingView.anchor
            .top(greaterOrEqual: topAnchor)
            .trailingToSuperview(constant: -horizontalMargin, toSafeArea: true)
            .bottom(lessOrEqual: bottomAnchor)
            .leading(to: contentView.trailingAnchor, constant: verticalMargin)
            .centerYToSuperview()
            .width(constant: ringRadius * 2)
            .height(constant: ringRadius * 2)
            .activate()
    }
    
    func configure(with viewModel: GradableCellPrimaryViewRepresentable) {
        gradeRingView.configure(with: viewModel.gradeRingViewModel)
        accentLabel.text = viewModel.accentText
        nameLabel.text = viewModel.name
        detailLabel.text = viewModel.detail
        let imageConfigurations = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .caption1))
        if let imageName = viewModel.systemImage, let image = UIImage(systemName: imageName, withConfiguration: imageConfigurations) {
            iconImageView.image = image
            iconImageView.tintColor = .secondaryLabel
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
        if viewModel.accentText != nil {
            nameLabelTopAnchor?.constant = 8
        } else {
            nameLabelTopAnchor?.constant = 0
        }
        layoutIfNeeded()
    }
}

class AssignmentCellPrimaryView: GradableCellPrimaryView {
    let finishedImageView: UIImageView = UIImageView()
    let topLine: UIView = UIView()
    let bottomLine: UIView = UIView()
    
    override func setupView() {
        super.setupView()
        contentViewLeadingAnchor?.deactivate()
        
        topLine.backgroundColor = .secondaryLabel
        bottomLine.backgroundColor = .secondaryLabel
        
        addSubview(finishedImageView)
        addSubview(topLine)
        addSubview(bottomLine)
        
        finishedImageView.anchor
            .centerYToSuperview()
            .width(constant: 20)
            .height(to: finishedImageView.widthAnchor)
            .leadingToSuperview(constant: 20)
            .trailing(to: contentView.leadingAnchor, constant: -15)
            .activate()
        
        topLine.anchor
            .centerX(to: finishedImageView.centerXAnchor)
            .width(constant: 1)
            .topToSuperview()
            .bottom(to: finishedImageView.topAnchor, constant: 1)
            .activate()
        
        bottomLine.anchor
            .centerX(to: finishedImageView.centerXAnchor)
            .width(constant: 1)
            .bottomToSuperview()
            .top(to: finishedImageView.bottomAnchor, constant: -1)
            .activate()
    }
    
    func configure(with viewModel: AssignmentCellPrimaryViewModel, position: AssignmentCellPrimaryViewModel.CellPosition) {
        super.configure(with: viewModel)
        if viewModel.isFinished {
            let image = UIImage(systemName: "checkmark.circle")!
            finishedImageView.image = image
            finishedImageView.tintColor = .systemGreen
        } else {
            let image = UIImage(systemName: "circle")!
            finishedImageView.image = image
            finishedImageView.tintColor = .secondaryLabel
        }
        
        switch position {
        case .first:
            topLine.isHidden = true
            bottomLine.isHidden = false
        case .middle:
            topLine.isHidden = false
            bottomLine.isHidden = false
        case .last:
            topLine.isHidden = false
            bottomLine.isHidden = true
        }
    }
}


// MARK: Secondary View
class GradableCellSecondaryView: UIView {
    private let verticalMargin: CGFloat = 15.0
    private let horizontalMargin: CGFloat = 20.0
    
    private let contentView: UIView = UIView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        return label
    }()
    private let progressView: UIProgressView = {
        let view = UIProgressView()
        view.backgroundColor = .systemGray3
        return view
    }()
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        addSubview(contentView)
        setupContentView()
    }
    
    private func setupContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(progressLabel)
        
        contentView.anchor
            .topToSuperview(constant: 8)
            .trailingToSuperview(constant: -horizontalMargin)
            .bottomToSuperview(constant: -8)
            .leadingToSuperview(constant: horizontalMargin)
            .activate()
        
         titleLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()

        progressView.anchor
            .top(to: titleLabel.bottomAnchor, constant: 8)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()

        progressLabel.anchor
            .top(to: progressView.bottomAnchor, constant: 3)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    func configure(with title: String, progress: Float, progressText: String? = nil) {
        titleLabel.text = title.uppercased()
        progressView.progress = progress
        progressLabel.text = progressText
    }
}


class TermCollectionViewCell: UICollectionViewCell, ReusableView {
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

