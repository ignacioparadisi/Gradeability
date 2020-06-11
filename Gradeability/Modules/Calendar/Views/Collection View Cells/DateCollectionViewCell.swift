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
    let notificationBadge: UIView = UIView()
    let selectedView = UIView()
    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let topLine = UIView()
        contentView.addSubview(topLine)
        contentView.addSubview(notificationBadge)
        contentView.addSubview(selectedView)
        topLine.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .height(constant: 2)
            .activate()
        
        notificationBadge.anchor
            .bottomToSuperview(constant: -10)
            .centerXToSuperview()
            .width(constant: 7)
            .height(to: notificationBadge.widthAnchor)
            .activate()
        
        notificationBadge.layer.cornerRadius = 3.5
        notificationBadge.clipsToBounds = true
        notificationBadge.backgroundColor = .systemRed
        topLine.backgroundColor = .systemGray5
        dateLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        
        dateLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottom(to: notificationBadge.topAnchor)
            .leadingToSuperview()
            .activate()
        
        selectedView.anchor
            .centerX(to: dateLabel.centerXAnchor)
            .centerY(to: dateLabel.centerYAnchor)
            .width(constant: 36)
            .height(to: selectedView.widthAnchor)
            .activate()
        
        selectedView.backgroundColor = .systemBlue
        selectedView.layer.cornerRadius = 18
        selectedView.clipsToBounds = true
        selectedView.isHidden = true
        notificationBadge.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
