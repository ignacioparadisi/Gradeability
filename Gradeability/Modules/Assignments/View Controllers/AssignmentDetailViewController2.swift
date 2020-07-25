//
//  AssignmentDetailViewController2.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class AssignmentDetailViewController2: BaseScrollViewController {
    
    private enum Section: Int, CaseIterable {
        case name
        case minGrade
        case maxGrade
        case grade
        case percentage
        case deadline
    }
    // MARK: Properties
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private let stackBackgroundView = UIView()
    private let gradeCardTextFieldView = GradeCardTextFieldView()
    private let viewModel: AssignmentDetailViewModel
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Initializers
    init(_ viewModel: AssignmentDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func setupView() {
        super.setupView()
        view.backgroundColor = .systemGroupedBackground
        contentView.addSubview(gradeCardTextFieldView)
        gradeCardTextFieldView.configure(with: viewModel.gradeCardViewModel2)
        gradeCardTextFieldView.anchor
            .topToSuperview(constant: 30, toSafeArea: true)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .activate()
        
        setupStackView()
        
        let deleteButton = UIButton()
        // Light: FFE5E3
        // Dark: #3D2220
        deleteButton.layer.cornerRadius = Constants.cornerRadius
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        contentView.addSubview(deleteButton)
        deleteButton.anchor
            .top(to: stackBackgroundView.bottomAnchor, constant: 20)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .bottomToSuperview(constant: -20, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .height(constant: 50)
            .activate()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
        viewModel.$name
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        let editButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.setRightBarButton(editButton, animated: false)
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    private func setupStackView() {
        stackBackgroundView.layer.cornerRadius = Constants.cornerRadius
        stackBackgroundView.backgroundColor = .secondarySystemGroupedBackground
        stackBackgroundView.addShadow()
        
        contentView.addSubview(stackBackgroundView)
        stackBackgroundView.addSubview(stackView)
        
        stackBackgroundView.anchor
            .top(to: gradeCardTextFieldView.bottomAnchor, constant: 30)
            .trailingToSuperview(constant: -16, toSafeArea: true)
            .leadingToSuperview(constant: 16, toSafeArea: true)
            .activate()
        
        stackView.anchor
            .topToSuperview(constant: 20)
            .trailingToSuperview(constant: -20)
            .bottomToSuperview(constant: -20)
            .leadingToSuperview(constant: 20)
            .activate()
        
        setupStackViewSubviews()
    }
    
    private func setupStackViewSubviews() {
        
        for section in Section.allCases {
            switch section {
            case .name:
                let nameTextField: UITextField = {
                    let textField = UITextField()
                    textField.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold
                    textField.adjustsFontForContentSizeCategory = true
                    return textField
                }()
                nameTextField.text = viewModel.name
                nameTextField.publisher(for: \.text)
                    .assign(to: \.name, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(nameTextField)
            case .minGrade:
                let view = DetailTextFieldView()
                view.configure(with: "Minimum grade to approve", text: viewModel.minGrade, keyboardType: .decimalPad)
                view.textField.publisher(for: \.text)
                    .assign(to: \.minGrade, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(view)
            case .maxGrade:
                let view = DetailTextFieldView()
                view.configure(with: "Maximum grade", text: viewModel.minGrade, keyboardType: .decimalPad)
                view.textField.publisher(for: \.text)
                    .assign(to: \.maxGrade, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(view)
            case .grade:
                let view = DetailTextFieldView()
                view.configure(with: "Grade", text: viewModel.minGrade, keyboardType: .decimalPad)
                view.textField.publisher(for: \.text)
                    .assign(to: \.grade, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(view)
            case .percentage:
                let view = DetailTextFieldView()
                view.configure(with: "Percentage", text: viewModel.percentage, keyboardType: .decimalPad)
                view.textField.publisher(for: \.text)
                    .assign(to: \.percentage, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(view)
            case .deadline:
                let view = DetailTextFieldView()
                view.configure(with: "Deadline", text: viewModel.deadline)
                view.textField.publisher(for: \.text)
                    .assign(to: \.deadline, on: viewModel)
                    .store(in: &subscriptions)
                stackView.addArrangedSubview(view)
            }
        }
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
//extension AssignmentDetailViewController: UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0 {
//            return 1
//        } else {
//            return Row.allCases.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(for: indexPath) as GradeCardTableViewCell
//            cell.configure(with: viewModel.gradeCardViewModel)
//            return cell
//        } else {
//            guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
//            switch row {
//            case .name:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as LargeTextFieldTableViewCell
//                cell.configure(with: viewModel.name)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.name, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            case .minGrade:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
//                cell.configure(with: "Minimum grade to approve", text: viewModel.minGrade, keyboardType: .decimalPad)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.minGrade, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            case .maxGrade:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
//                cell.configure(with: "Maximum grade", text: viewModel.minGrade, keyboardType: .decimalPad)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.maxGrade, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            case .grade:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
//                cell.configure(with: "Grade", text: viewModel.grade, keyboardType: .decimalPad)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.grade, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            case .percentage:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
//                cell.configure(with: "Percentage", text: viewModel.percentage, keyboardType: .decimalPad)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.percentage, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            case .deadline:
//                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
//                cell.configure(with: "Deadline", text: viewModel.deadline)
//                cell.textField.publisher(for: \.text)
//                    .assign(to: \.deadline, on: viewModel)
//                    .store(in: &subscriptions)
//                return cell
//            default:
//                return UITableViewCell()
//            }
//        }
//    }
//
//}
