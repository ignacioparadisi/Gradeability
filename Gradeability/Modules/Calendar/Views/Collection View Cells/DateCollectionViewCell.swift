//
//  DateCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DateCollectionViewCell: JTACDayCell, ReusableView {
    
    let dateLabel: UILabel = UILabel()
    let notificationBadgeView: UIView = UIView()
    let selectedView = UIView()
    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let topLine = UIView()
        topLine.backgroundColor = .systemGray5
        
        contentView.addSubview(topLine)
        contentView.addSubview(notificationBadgeView)
        contentView.addSubview(selectedView)
        contentView.addSubview(dateLabel)
        
        topLine.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .height(constant: 2)
            .activate()
        
        setupNotificationBadge()
        setupSelectedView()
        setupDateLabel()
    }
    
    /// Add the `notificationBadgeView` to the view and configures it
    private func setupNotificationBadge() {
        notificationBadgeView.layer.cornerRadius = 3.5
        notificationBadgeView.clipsToBounds = true
        notificationBadgeView.backgroundColor = .systemRed
        notificationBadgeView.isHidden = true
        notificationBadgeView.anchor
            .bottomToSuperview(constant: -10)
            .centerXToSuperview()
            .width(constant: 7)
            .height(to: notificationBadgeView.widthAnchor)
            .activate()
    }
    
    /// Add the `selectedView` to the view and configures it
    private func setupSelectedView() {
        selectedView.backgroundColor = .systemBlue
        selectedView.layer.cornerRadius = 18
        selectedView.clipsToBounds = true
        selectedView.isHidden = true
        selectedView.anchor
            .centerX(to: dateLabel.centerXAnchor)
            .centerY(to: dateLabel.centerYAnchor)
            .width(constant: 36)
            .height(to: selectedView.widthAnchor)
            .activate()
    }
    /// Add the `dateLabel` to the view and configures it
    private func setupDateLabel() {
        dateLabel.textAlignment = .center
        dateLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottom(to: notificationBadgeView.topAnchor)
            .leadingToSuperview()
            .activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure the cell depending on the state and the date displayed
    /// - Parameters:
    ///   - state: Cell state
    ///   - date: Date to be displayed
    func configure(with state: CellState, forDate date: Date) {
        dateLabel.text = state.text
        handleTextColor(state: state)
    }
    
    /// Setup the text color depending if the date corresponds to the current month or not
    /// - Parameter state: Cell state
    func handleTextColor(state: CellState) {
        if state.dateBelongsTo == .thisMonth {
            dateLabel.textColor = .label
        } else {
            dateLabel.textColor = .tertiaryLabel
        }
    }
}