//
//  GradeCardTableViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeCardTableViewCell: UITableViewCell, ReusableView {
    /// Card view for the current grade
    private let gradeCardView = GradeCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(gradeCardView)
        addShadow()
        gradeCardView.anchor
            .topToSuperview(constant: 10)
            .trailingToSuperview(constant: -16)
            .bottomToSuperview(constant: -10)
            .leadingToSuperview(constant: 16)
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
