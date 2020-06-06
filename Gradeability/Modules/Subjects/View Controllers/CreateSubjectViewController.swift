//
//  CreateSubjectViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class CreateSubjectViewController: UIViewController {
    
    // MARK: Properties
    /// View Model for the view controller
    let viewModel: CreateSubjectViewModel = CreateSubjectViewModel()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Subject"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
}
