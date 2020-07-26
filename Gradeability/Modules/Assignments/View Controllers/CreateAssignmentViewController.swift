//
//  CreateAssignmentViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class FieldSectionView: UIView {
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let control: UIControl
    lazy var controlBackgroundView = UIView()
    var controlHeightAnchor: Anchor?
    
    init(title: String, description: String, control: UIControl) {
        self.control = control
        super.init(frame: .zero)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1).bold
        titleLabel.text = title
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = description
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
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
        
        if control is UIDatePicker {
            let button = UIButton()
            let date = Date()
            let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
            button.setTitle(dateFormatter.string(from: date), for: .normal)
            button.backgroundColor = .systemGray5
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            button.contentHorizontalAlignment = .leading
            button.addTarget(self, action: #selector(toggleDatePickerVisibility), for: .touchUpInside)
            addSubview(button)
            button.anchor
                .top(to: descriptionLabel.bottomAnchor, constant: 10)
                .trailing(to: titleLabel.trailingAnchor)
                .leading(to: titleLabel.leadingAnchor)
                .bottomToSuperview()
                .activate()
            
            controlBackgroundView.backgroundColor = .systemGray5
            controlBackgroundView.layer.cornerRadius = 10
            controlBackgroundView.clipsToBounds = true
            addSubview(controlBackgroundView)
            controlBackgroundView.addSubview(control)
            controlBackgroundView.anchor
                .top(to: button.bottomAnchor, constant: 5)
                .trailing(to: titleLabel.trailingAnchor)
                .leading(to: titleLabel.leadingAnchor)
                .bottomToSuperview()
                .activate()
            control.anchor
                .topToSuperview(constant: 10)
                .trailing(lessOrEqual: controlBackgroundView.trailingAnchor, constant: -16)
                .leading(greaterOrEqual: controlBackgroundView.leadingAnchor, constant: 16)
                .bottomToSuperview(constant: -10)
                .centerXToSuperview()
                .activate()
            controlHeightAnchor = controlBackgroundView.anchor.height(constant: 0)
            controlHeightAnchor?.activate()
            controlBackgroundView.isHidden = true
//            control.anchor
//                .top(to: descriptionLabel.bottomAnchor, constant: 10)
//                .trailing(lessOrEqual: titleLabel.trailingAnchor)
//                .leading(greaterOrEqual: titleLabel.leadingAnchor)
//                .bottomToSuperview()
//                .centerXToSuperview()
//                .activate()
        } else {
            addSubview(control)
            control.anchor
                .top(to: descriptionLabel.bottomAnchor, constant: 10)
                .trailing(to: titleLabel.trailingAnchor)
                .leading(to: titleLabel.leadingAnchor)
                .bottomToSuperview()
                .activate()
        }
    }
    
    @objc private func toggleDatePickerVisibility() {
        if controlBackgroundView.isHidden {
            controlHeightAnchor?.deactivate()
        } else {
            controlHeightAnchor?.activate()
        }
        self.controlBackgroundView.isHidden.toggle()
        
//        UIView.animate(withDuration: 0.3, animations: {
//            self.layoutSubviews()
//            
//        })
    }
}

class CreateAssignmentViewController: BaseScrollViewController {
    
    // MARK: Properties
    /// View Model for the view controller
    private let viewModel: CreateAssignmentViewModel = CreateAssignmentViewModel()
    private var nameFieldSection: FieldSectionView!
    private var deadlineFieldSection: FieldSectionView!
    
    /// Setup the navigation bar
    override func setupNavigationBar() {
        super.setupNavigationBar()
        title = AssignmentString.createAssignment.localized
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    /// Setup the view
    override func setupView() {
        super.setupView()
        setupNameSection()
        setupDeadlineSection()
    }
    
    /// Setup textfield for getting the assignment's name
    private func setupNameSection() {
        let textField = GRDTextField()
        textField.placeholder = AssignmentString.insertName.localized
        nameFieldSection =  FieldSectionView(title: GlobalStrings.name.localized, description: AssignmentString.assignmentsName.localized, control: textField)
        contentView.addSubview(nameFieldSection)
        nameFieldSection.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    private func setupDeadlineSection() {
        let datePicker = UIDatePicker()
        deadlineFieldSection =  FieldSectionView(title: "Deadline", description: AssignmentString.assignmentsName.localized, control: datePicker)
        contentView.addSubview(deadlineFieldSection)
        deadlineFieldSection.anchor
            .top(to: nameFieldSection.bottomAnchor)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        let switchLabel = UILabel()
        switchLabel.text = "Create event in Calendar"
        let calendarSwitch = UISwitch()
        calendarSwitch.isOn = true
        
        let switchView = UIView()
        switchView.backgroundColor = .systemGray5
        switchView.layer.cornerRadius = 10
        switchView.clipsToBounds = true
        switchView.addSubview(switchLabel)
        switchView.addSubview(calendarSwitch)
        
        contentView.addSubview(switchView)
        
        switchView.anchor
            .top(to: deadlineFieldSection.bottomAnchor, constant: 5)
            .trailingToSuperview(constant: -20)
            .bottomToSuperview()
            .leadingToSuperview(constant: 20)
            .activate()
        
        switchLabel.anchor
            .topToSuperview(constant: 10)
            .leadingToSuperview(constant: 16)
            .bottomToSuperview(constant: -10)
            .height(to: calendarSwitch.heightAnchor, priority: .defaultLow)
            .activate()
        calendarSwitch.anchor
            .leading(to: switchLabel.trailingAnchor, constant: 20)
            .trailingToSuperview(constant: -16)
            .centerY(to: switchLabel.centerYAnchor)
            .activate()
    }
    
    /// Dismiss view on close button tap
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
}

