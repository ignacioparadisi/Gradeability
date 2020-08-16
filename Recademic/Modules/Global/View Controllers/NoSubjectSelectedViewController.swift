//
//  NoSubjectSelectedViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class NoSubjectSelectedViewController: UIViewController {
    /// Title label for the view
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3).bold
        label.textAlignment = .center
        label.text = SubjectStrings.noSubjectSelectedTitle.localized
        return label
    }()
    /// Detail label for the view
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.text = SubjectStrings.noSubjectSelectedMessage.localized
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleLabel)
        view.addSubview(detailLabel)
        
        titleLabel.anchor
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .bottom(to: view.centerYAnchor, constant: -5)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .centerXToSuperview()
            .activate()
        
        detailLabel.anchor
            .top(to: view.centerYAnchor, constant: 5)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .centerXToSuperview()
            .activate()
    }
}
