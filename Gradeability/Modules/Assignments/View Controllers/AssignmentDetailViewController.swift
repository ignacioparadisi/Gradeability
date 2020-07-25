//
//  AssignmentDetailViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class AssignmentDetailViewController: UIViewController {
    
    private enum Row: Int, CaseIterable {
        case name
        case minGrade
        case maxGrade
        case grade
        case percentage
        case deadline
    }
    // MARK: Properties
    private let tableView: UITableView = UITableView()
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableView()
        setupViewModel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.register(GradeCardTableViewCell.self)
        tableView.register(LargeTextFieldTableViewCell.self)
        tableView.register(DetailTextFieldTableViewCell.self)
    }
    
    func setupViewModel() {
        viewModel.$name
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
    }
    
    func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView))
        let editButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: nil)
        navigationItem.setRightBarButton(editButton, animated: false)
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AssignmentDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return Row.allCases.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradeCardTableViewCell
            cell.configure(with: viewModel.gradeCardViewModel)
            return cell
        } else if indexPath.item == Row.allCases.count {
            let deleteButton = UIButton()
            deleteButton.layer.cornerRadius = Constants.cornerRadius
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.setTitle("Delete", for: .normal)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.contentView.addSubview(deleteButton)
            deleteButton.anchor
                .height(constant: 50)
                .edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 16, bottom: -10, right: -16))
                .activate()
            return cell
        } else {
            guard let row = Row(rawValue: indexPath.row) else { return UITableViewCell() }
            switch row {
            case .name:
                let cell = tableView.dequeueReusableCell(for: indexPath) as LargeTextFieldTableViewCell
                cell.configure(with: viewModel.name)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.name, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            case .minGrade:
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
                cell.configure(with: "Minimum grade to approve", text: viewModel.minGrade, keyboardType: .decimalPad)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.minGrade, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            case .maxGrade:
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
                cell.configure(with: "Maximum grade", text: viewModel.minGrade, keyboardType: .decimalPad)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.maxGrade, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            case .grade:
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
                cell.configure(with: "Grade", text: viewModel.grade, keyboardType: .decimalPad)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.grade, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            case .percentage:
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
                cell.configure(with: "Percentage", text: viewModel.percentage, keyboardType: .decimalPad)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.percentage, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            case .deadline:
                let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell
                cell.configure(with: "Deadline", text: viewModel.deadline)
                cell.textField.publisher(for: \.text)
                    .assign(to: \.deadline, on: viewModel)
                    .store(in: &subscriptions)
                return cell
            default:
                return UITableViewCell()
            }
        }
    }
    
}


