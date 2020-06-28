//
//  AssignmentCellPrimaryView.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentCellPrimaryView: GradableCellPrimaryView {
    let finishedImageView: UIImageView = UIImageView()
    let topLine: UIView = UIView()
    let bottomLine: UIView = UIView()
    
    override func setupView() {
        super.setupView()
        contentViewLeadingAnchor?.deactivate()
        
        topLine.backgroundColor = .secondaryLabel
        bottomLine.backgroundColor = .secondaryLabel
        
        addSubview(finishedImageView)
        addSubview(topLine)
        addSubview(bottomLine)
        
        finishedImageView.anchor
            .centerYToSuperview()
            .width(constant: 22)
            .height(to: finishedImageView.widthAnchor)
            .leadingToSuperview(constant: 20)
            .trailing(to: contentView.leadingAnchor, constant: -15)
            .activate()
        
        topLine.anchor
            .centerX(to: finishedImageView.centerXAnchor)
            .width(constant: 1)
            .topToSuperview()
            .bottom(to: finishedImageView.topAnchor, constant: 1)
            .activate()
        
        bottomLine.anchor
            .centerX(to: finishedImageView.centerXAnchor)
            .width(constant: 1)
            .bottomToSuperview()
            .top(to: finishedImageView.bottomAnchor, constant: -1)
            .activate()
    }
    
    func configure(with viewModel: AssignmentCellPrimaryViewModel, position: AssignmentCellPrimaryViewModel.CellPosition) {
        super.configure(with: viewModel)
        if viewModel.isFinished {
            let image = UIImage(systemName: "checkmark.circle")!
            finishedImageView.image = image
            finishedImageView.tintColor = .systemGreen
        } else {
            let image = UIImage(systemName: "circle")!
            finishedImageView.image = image
            finishedImageView.tintColor = .secondaryLabel
        }
        
        switch position {
        case .only:
            topLine.isHidden = true
            bottomLine.isHidden = true
        case .first:
            topLine.isHidden = true
            bottomLine.isHidden = false
        case .middle:
            topLine.isHidden = false
            bottomLine.isHidden = false
        case .last:
            topLine.isHidden = false
            bottomLine.isHidden = true
        }
    }
}
