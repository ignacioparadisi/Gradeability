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
    private let gradeCardView = GradeCardView()
    private lazy var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private lazy var teacherEmailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private lazy var classRoomNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        return label
    }()
    private lazy var progressLineView = ProgressLineView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .cellSecondaryBackgroundColor
        layer.cornerRadius = Constants.cornerRadius
        contentView.addSubview(gradeCardView)
        contentView.layer.cornerRadius = Constants.cornerRadius
        addShadow()
        gradeCardView.anchor
            .topToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .activate()
        
        if UIDevice.current.userInterfaceIdiom == .pad && frame.width > 400 {
            gradeCardView.anchor.width(to: contentView.widthAnchor, multiplier: 0.6).activate()
            addInformationView()
        } else {
            gradeCardView.anchor.trailingToSuperview().activate()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Configure the cell with the view model's information.
    /// - Parameter representable: View model for the cell.
    func configure(with representable: GradesCardCollectionViewCellRepresentable) {
        gradeCardView.configure(with: representable.gradeCardViewModel)
    }
    
    private func addInformationView() {
        let informationView = UIView()
        informationView.backgroundColor = .clear
        let teacherLabel = UILabel()
        teacherLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        teacherLabel.text = "Teacher".uppercased()
        let classRoomLabel = UILabel()
        classRoomLabel.font = UIFont.preferredFont(forTextStyle: .caption1).bold
        classRoomLabel.text = "Classroom".uppercased()
        
        contentView.addSubview(informationView)
        informationView.addSubview(teacherLabel)
        informationView.addSubview(teacherNameLabel)
        informationView.addSubview(teacherEmailLabel)
        informationView.addSubview(classRoomLabel)
        informationView.addSubview(classRoomNameLabel)
        informationView.addSubview(progressLineView)
        
        informationView.anchor
            .topToSuperview(constant: 10)
            .trailingToSuperview(constant: -20)
            .bottomToSuperview(constant: -10)
            .leading(to: gradeCardView.trailingAnchor, constant: 20)
            .activate()
        
        teacherLabel.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        teacherNameLabel.anchor
            .top(to: teacherLabel.bottomAnchor, constant: 5)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        teacherEmailLabel.anchor
            .top(to: teacherNameLabel.bottomAnchor, constant: 5)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        classRoomLabel.anchor
            .top(to: teacherEmailLabel.bottomAnchor, constant: 15)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        classRoomNameLabel.anchor
            .top(to: classRoomLabel.bottomAnchor, constant: 5)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        progressLineView.anchor
            .top(to: classRoomNameLabel.bottomAnchor, constant: 15)
            .trailingToSuperview()
            .leadingToSuperview()
            .bottomToSuperview()
            .activate()
        
        progressLineView.configure(with: "Porcentaje evaluado", progress: 0.3, progressText: "30%")
        teacherNameLabel.text = "Pepito Perez"
        teacherEmailLabel.text = "pepitoperez@gmail.com"
        classRoomNameLabel.text = "A-13"
        
    }
}
