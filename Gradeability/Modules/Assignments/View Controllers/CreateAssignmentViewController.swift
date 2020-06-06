//
//  CreateAssignmentViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CreateAssignmentViewController: UIViewController {
    
    // MARK: Properties
    /// View Model for the view controller
    private let viewModel: CreateAssignmentViewModel = CreateAssignmentViewModel()
    /// ScrollView where the views are placed
    private let scrollView = UIScrollView()
    /// View that contains all the subviews. All subviews should be held for the `contentView` instead of the `scrollView`
    private let contentView = UIView()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    /// Setup the navigation bar
    private func setupNavigationBar() {
        title = AssignmentString.createAssignment.localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    /// Setup the view
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor.edgesToSuperview().activate()
        contentView.anchor
            .edgesToSuperview()
            .width(to: scrollView.widthAnchor)
            .height(to: scrollView.heightAnchor, priority: .defaultLow)
            .activate()
        
        setupNameSection()
    }
    
    /// Setup textfield for getting the assignment's name
    private func setupNameSection() {
        let titleLabel = UILabel()
        let descriptionLabel = UILabel()
        let textField = GRDTextField()
        
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        // titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.text = GlobalStrings.name.localized
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = AssignmentString.insertName.localized
        textField.placeholder = AssignmentString.assignmentsName.localized
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(textField)
        
        titleLabel.anchor
            .topToSuperview(constant: 20)
            .trailingToSuperview(constant: -20)
            .leadingToSuperview(constant: 20)
            .activate()
        
        descriptionLabel.anchor
            .top(to: titleLabel.bottomAnchor, constant: 5)
            .trailing(to: titleLabel.trailingAnchor)
            .leading(to: titleLabel.leadingAnchor)
            .activate()
        
        textField.anchor
            .top(to: descriptionLabel.bottomAnchor, constant: 10)
            .trailing(to: titleLabel.trailingAnchor)
            .leading(to: titleLabel.leadingAnchor)
            .bottomToSuperview()
            .activate()
    }
    
    /// Dismiss view on close button tap
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
}

