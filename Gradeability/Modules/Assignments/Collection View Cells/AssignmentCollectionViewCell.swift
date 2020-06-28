//
//  AssignmentCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentCollectionViewCell: UICollectionViewCell, ReusableView {
    
    private let primaryCellView = AssignmentCellPrimaryView()

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        layer.cornerRadius = 15
        contentView.addSubview(primaryCellView)
        primaryCellView.anchor
            .edgesToSuperview()
            .activate()
    }
    
    func configure(with viewModel: GradableCellViewModelRepresentable, position: AssignmentCellPrimaryViewModel.CellPosition) {
        primaryCellView.configure(with: viewModel.primaryViewModel as! AssignmentCellPrimaryViewModel, position: position)
    }
    
}
