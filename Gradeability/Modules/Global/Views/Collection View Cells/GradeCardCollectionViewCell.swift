//
//  GradeCardCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradesCardCollectionViewCell: UICollectionViewCell, ReusableView {
    /// Card view for the current grade
    let gradeCardView = GradeCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.addSubview(gradeCardView)
        gradeCardView.anchor
            .topToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .trailingToSuperview()
            .activate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure the cell with the view model's information.
    /// - Parameter representable: View model for the cell.
    func configure(with representable: GradesCardCollectionViewCellRepresentable) {
        gradeCardView.configure(with: representable.gradeCardViewModel)
    }
}
