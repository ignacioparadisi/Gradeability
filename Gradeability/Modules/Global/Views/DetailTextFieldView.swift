//
//  DetailTextFieldView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class DetailTextFieldView: UIView {
    
    // MARK: Properties
    var textField: UITextField = {
        let textField = UITextField()
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        return label
    }()
    private var verticalMargin: CGFloat = 0
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    private func setupView() {
        addSubview(titleLabel)
        addSubview(textField)

        titleLabel.anchor
            .topToSuperview(constant: 10)
            .trailingToSuperview(constant: -verticalMargin)
            .leadingToSuperview(constant: verticalMargin)
            .activate()

        textField.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .trailingToSuperview(constant: -verticalMargin)
            .leadingToSuperview(constant: verticalMargin)
            .bottomToSuperview(constant: -10)
            .activate()
    }
    
    func configure(with title: String, text: String?, keyboardType: UIKeyboardType = .default) {
        titleLabel.text = title.uppercased()
        textField.text = text
        textField.keyboardType = keyboardType
    }
}

