//
//  AssignmentDetailViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentDetailViewModel {
    private let assignment: Assignment
    var name: String {
        return assignment.name ?? ""
    }
    var grade: String {
        return "\(assignment.grade)"
    }
    var percentage: String {
        return "\(assignment.percentage * 100)%"
    }
    
    init(_ assignment: Assignment) {
        self.assignment = assignment
    }
}

class AssignmentDetailViewController: UIViewController {
    // MARK: Properties
    let viewModel: AssignmentDetailViewModel
    let nameLabel: UILabel = UILabel()
    let gradeLabel: UILabel = UILabel()
    let percentageLabel: UILabel = UILabel()
    
    // MARK: Initializers
    init(_ viewModel: AssignmentDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(nameLabel)
        view.addSubview(gradeLabel)
        view.addSubview(percentageLabel)
        
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
        
        percentageLabel.anchor
            .top(to: gradeLabel.bottomAnchor, constant: 10)
            .trailingToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 20, toSafeArea: true)
            .activate()
        
        setupView()
        setupNavigationBar()
    }
    
    func setupView() {
        nameLabel.text = viewModel.name
        gradeLabel.text = viewModel.grade
        percentageLabel.text = viewModel.percentage
    }
    
    func setupNavigationBar() {
        title = "Detail"
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: nil)
        navigationItem.setRightBarButton(editButton, animated: false)
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}
