//
//  LargeTextFieldTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class LargeTextFieldTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: Properties
    private var field: FieldRepresentable?
    private let verticalMargin: CGFloat = 20
    private var subscription: AnyCancellable?
    var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold
        textField.adjustsFontForContentSizeCategory = true
        return textField
    }()
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(textField)
        textField.anchor.edgesToSuperview(insets: UIEdgeInsets(top: 10, left: verticalMargin, bottom: -10, right: -verticalMargin)).activate()
    }
    
    func configure(with text: String?, placeholder: String? = nil) {
        textField.text = text
        textField.placeholder = placeholder
    }
    
    func configure(with field: FieldRepresentable) {
        self.field = field
        textField.text = field.stringValue
        textField.placeholder = field.title
    }
    
    func createSubscription() {
        subscription = textField.publisher(for: \.text)
            .assign(to: \.stringValue, on: field)
    }
}
