//
//  DetailTextFieldTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class DetailTextFieldTableViewCell<Coder: StringCoder>: UITableViewCell, ReusableView, UITextFieldDelegate {
    
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
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(changeDate), for: .valueChanged)
        return datePicker
    }()
    private var verticalMargin: CGFloat = 20
    private var subscriptions = Set<AnyCancellable>()
    @Published var value: Coder.T?
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
            .map { Coder.decode(string: $0) }
            .assign(to: \.value, on: self)
            .store(in: &subscriptions)
    }
    
    func configure(with title: String, value: Coder.T?, keyboardType: UIKeyboardType = .default) {
        titleLabel.text = title.uppercased()
        textField.text = Coder.encode(value: value)
        textField.keyboardType = keyboardType
        
        if Coder.self == Date.self {
            textField.tintColor = .clear
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                if let date = value as? Date {
                    datePicker.date = date
                }
                textField.inputView = datePicker
            } else {
                textField.isUserInteractionEnabled = false
            }
        }
        
        print(subscriptions.count)
    }
    
    @objc private func changeDate() {
        textField.text = DateFormatter.longDateShortTimeDateFormatter.string(from: datePicker.date)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.textColor = .systemBlue
    }
}
