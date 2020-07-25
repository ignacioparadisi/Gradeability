//
//  AssignmentDetailViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentDetailView

class AssignmentDetailViewController: UIViewController {
    let nameLabel: UILabel = UILabel()
    let gradeLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(nameLabel)
        view.addSubview(gradeLabel)
        
        nameLabel.anchor
            .topToSuperview(constant:20, toSafeArea: true)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 20, toSafeArea: true)
        .activate()
        
        gradeLabel.anchor
            .top(to: nameLabel.bottomAnchor, constant: 10)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .activate()
    }
}
