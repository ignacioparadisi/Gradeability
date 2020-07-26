//
//  DetailTextFieldTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

protocol StringCoder {
    associatedtype T
    static func decode(string: String?) -> T?
    static func encode(value: T?) -> String?
}

extension String: StringCoder {
    typealias T = String
    static func decode(string: String?) -> String? {
        return string
    }
    static func encode(value: String?) -> String? {
        return value
    }
}

extension Float: StringCoder {
    typealias T = Float
    static func decode(string: String?) -> Float? {
        guard let string = string else { return nil }
        return Float(string)
    }
    static func encode(value: Float?) -> String? {
        guard let value = value else { return nil }
        return "\(value)"
    }
}

extension Date: StringCoder {
    typealias T = Date
    static func decode(string: String?) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
        return dateFormatter.date(from: string)
    }
    static func encode(value: Date?) -> String? {
        guard let value = value else { return nil }
        let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
        return dateFormatter.string(from: value)
    }
}

class DetailTextFieldTableViewCell<Coder: StringCoder>: UITableViewCell, ReusableView {
    
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
        
        if let date = value as? Date {
            textField.tintColor = .clear
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                datePicker.date = date
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
}
