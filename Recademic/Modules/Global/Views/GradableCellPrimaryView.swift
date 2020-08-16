//
//  GradableCellPrimaryView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradableCellPrimaryView: UIView {
    // MARK: Constant Properties
    private let verticalMargin: CGFloat = 15.0
    private let horizontalMargin: CGFloat = 20.0
    private let ringRadius: CGFloat = 22.0
    
    // MARK: View Properties
    private var gradeRingView: GradeRingView!
    lazy var iconImageView: UIImageView = UIImageView()
    let contentView: UIView = UIView()
    private let accentLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.textColor = .systemBlue
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 2
        return label
    }()
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
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
        layer.cornerRadius = Constants.cornerRadius
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
    
    func setHighlighted(_ isHighlighted: Bool) {
        if isHighlighted {
            backgroundColor = .systemGray4
        } else {
            backgroundColor = .secondarySystemGroupedBackground
        }
    }
}
