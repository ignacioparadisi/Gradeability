//
//  CircularSliderTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CircularSliderTableViewCell: UITableViewCell, ReusableView {
    
    private let circularSlider = CircularSlider()
    var gestureDelegate: UIGestureRecognizerDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(circularSlider)
        let multiplier: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.5
        circularSlider.anchor
            .centerXToSuperview()
            .topToSuperview(constant: 30)
            .bottomToSuperview(constant: 40)
            .width(to: contentView.widthAnchor, multiplier: multiplier)
            .height(to: circularSlider.widthAnchor)
            .activate()
        
        setupSlider()
    }
    
    private func setupSlider() {
        circularSlider.lineWidth = 40
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = 20
        circularSlider.knobRadius = 46
        circularSlider.bgColor = .systemGray4
        circularSlider.title = "Grade".uppercased()
    }
}
