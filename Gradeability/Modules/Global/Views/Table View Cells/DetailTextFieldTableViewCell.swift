//
//  DetailTextFieldTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class DetailTextFieldTableViewCell: UITableViewCell, ReusableView, UITextFieldDelegate {
    
    // MARK: Properties
    private var field: FieldRepresentable?
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
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        return datePicker
    }()
    private var verticalMargin: CGFloat = 20
    private var subscriptions = Set<AnyCancellable>()
    @Published var value: String?
    var isValid: Bool? {
        didSet {
            guard let isValid = isValid else {
                titleLabel.textColor = .secondaryLabel
                return
            }
            titleLabel.textColor = isValid ? .systemBlue : .systemRed
        }
    }
    
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(textField)

        textField.delegate = self
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
        
        textField
            .publisher(for: \.text)
            .assign(to: \.value, on: self)
            .store(in: &subscriptions)
    }
    
    func configure(with field: FieldRepresentable) {
        self.field = field
        titleLabel.text = field.title.uppercased()
        textField.text = field.stringValue
        textField.placeholder = field.placeholder
        switch field.type {
        case .decimalTextField:
            textField.keyboardType = .decimalPad
        case .datePicker:
            textField.tintColor = .clear
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                if let field = field as? Field<Date>, let date = field.value {
                    datePicker.date = date
                }
                textField.inputView = datePicker
            } else {
                textField.isUserInteractionEnabled = false
            }
        default:
            break
        }
    }
    
    @objc private func changeDate() {
        textField.text = DateFormatter.longDateShortTimeDateFormatter.string(from: datePicker.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = .systemBlue
    }
}
