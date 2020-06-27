//
//  CreateTermViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class CreateTermViewController: BaseScrollViewController {
    
    private let viewModel: CreateTermViewModel = CreateTermViewModel()
    private var subscribers = Set<AnyCancellable>()
    private let sections: [FieldSectionView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Term"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem?.isEnabled = false
        setupViewModel()
        setupSections()
    }

    @objc private func dismissView() {
        dismiss(animated: true)
    }

    private func setupViewModel() {
        if let saveButton = navigationItem.rightBarButtonItem {
            viewModel.$canSave
                .assign(to: \.isEnabled, on: saveButton)
                .store(in: &subscribers)
        }
    }
    
    private func setupSections() {
        let nameTextField = GRDTextField()
        nameTextField
            .publisher(for: \.text)
            .assign(to: \.name, on: viewModel)
            .store(in: &subscribers)
        let nameSection = FieldSectionView(title: "Name", description: "Insert the name for the Term.", control: nameTextField)
        
        let maxGradeTextField = GRDTextField()
        maxGradeTextField.keyboardType = .decimalPad
        maxGradeTextField
            .publisher(for: \.text)
            .replaceNil(with: "")
            .compactMap { Float($0) }
            .assign(to: \.maxGrade, on: viewModel)
            .store(in: &subscribers)
        let maxGradeSection = FieldSectionView(title: "Maximum Grade", description: "Insert the name for the Term.", control: maxGradeTextField)
        
        let minGradeTextField = GRDTextField()
        minGradeTextField.keyboardType = .decimalPad
        minGradeTextField
            .publisher(for: \.text)
            .replaceNil(with: "")
            .compactMap { Float($0) }
            .assign(to: \.minGrade, on: viewModel)
            .store(in: &subscribers)
        let minGradeSection = FieldSectionView(title: "Minimum Grade to Approve", description: "Insert the name for the Term.", control: minGradeTextField)
        
        contentView.addSubview(nameSection)
        contentView.addSubview(maxGradeSection)
        contentView.addSubview(minGradeSection)
        
        nameSection.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        maxGradeSection.anchor
            .top(to: nameSection.bottomAnchor)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        minGradeSection.anchor
            .top(to: maxGradeSection.bottomAnchor)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        
    }
    
}

