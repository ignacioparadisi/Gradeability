//
//  SwitchTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class SwitchTableViewCell: UITableViewCell, ReusableView {
    
    // MARK: Properties
    private let `switch`: UISwitch = UISwitch()
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemBlue
        label.numberOfLines = 0
        return label
    }()
    private var subscription: AnyCancellable?
    @Published var value: Bool = true
    
    // MARK: Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: Functions
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(`switch`)
        contentView.addSubview(titleLabel)
        
        titleLabel.anchor
            .topToSuperview(constant: 10)
            .bottomToSuperview(constant: -10)
            .leadingToSuperview(constant: 20)
            .activate()
        
        `switch`.anchor
            .top(greaterOrEqual: contentView.topAnchor, constant: 10)
            .trailingToSuperview(constant: -20)
            .bottom(lessOrEqual: contentView.bottomAnchor, constant: -10)
            .leading(to: titleLabel.trailingAnchor, constant: 16)
            .centerY(to: titleLabel.centerYAnchor)
            .activate()
        
        subscription = `switch`.publisher(for: \.isOn)
            .assign(to: \.value, on: self)
    }
    
    func configure(with title: String, value: Bool = true) {
        self.titleLabel.text = title.uppercased()
        self.`switch`.isOn = value
    }
    
    func toggle() {
        `switch`.isOn.toggle()
    }
}
