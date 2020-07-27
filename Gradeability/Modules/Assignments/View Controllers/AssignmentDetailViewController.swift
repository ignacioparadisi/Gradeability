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
    
    private enum Section: Int, CaseIterable {
        case grade
        case fields
        case delete
    }
    private enum FieldRow: Int, CaseIterable {
        case minGrade
        case maxGrade
        case percentage
        case deadline
    }
    // MARK: Properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private let viewModel: AssignmentDetailViewModel
    private var saveButton: UIBarButtonItem!
    private var subscriptions = Set<AnyCancellable>()
    private var cellSubscriptions = Set<AnyCancellable>()
    private var gradeSubscriptions = Set<AnyCancellable>()
    
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
        // tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.register(CircularSliderTableViewCell.self)
        tableView.register(LargeTextFieldTableViewCell.self)
        tableView.register(DetailTextFieldTableViewCell<Float>.self)
        tableView.register(DetailTextFieldTableViewCell<Date>.self)
    }
    
    func setupViewModel() {
        viewModel.$name
            .receive(on: RunLoop.main)
            .assign(to: \.title, on: self)
            .store(in: &subscriptions)
        viewModel.readyToSubmit
            .map { $0 != nil }
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &subscriptions)
    }
    
    func setupNavigationBar() {
        let closeButton = UIBarButtonItem(title: ButtonStrings.close.localized, style: .plain, target: self, action: #selector(dismissView))
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.setLeftBarButton(closeButton, animated: false)
    }
    
    @objc private func dismissView() {
        dismiss(animated: true)
    }
    
    @objc private func save() {
        viewModel.save()
        dismissView()
    }
    
    func showDatePickerPopover(_ sender: UITableViewCell) {
        let datePicker = UIDatePicker()
        let datePickerSize = CGSize(width: 320, height: 200)
        datePicker.frame = CGRect(x: 0, y: 0, width: datePickerSize.width, height: datePickerSize.height)
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = viewModel.deadline ?? Date()
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        let popoverView = UIView()
        popoverView.backgroundColor = UIColor.clear
        popoverView.addSubview(datePicker)
        
        let popoverViewController = UIViewController()
        popoverViewController.view = popoverView
        popoverViewController.view.frame = CGRect(x: 0, y: 0, width: datePickerSize.width, height: datePickerSize.height)
        popoverViewController.modalPresentationStyle = .popover
        popoverViewController.preferredContentSize = datePickerSize
        popoverViewController.popoverPresentationController?.sourceView = sender
        popoverViewController.popoverPresentationController?.sourceRect = sender.bounds
        self.present(popoverViewController, animated: true, completion: nil)
        
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let indexPath = IndexPath(row: FieldRow.deadline.rawValue, section: Section.fields.rawValue)
        guard let cell = tableView.cellForRow(at: indexPath) as? DetailTextFieldTableViewCell<Date> else { return }
        cell.textField.text = DateFormatter.longDateShortTimeDateFormatter.string(from: sender.date)
    }
}

// MARK: - UITableViewDataSource
extension AssignmentDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .grade:
            return 2
        case .fields:
            return FieldRow.allCases.count
        case .delete:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .grade:
            let shouldCreateSubscription = gradeSubscriptions.count <= 3
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(for: indexPath) as CircularSliderTableViewCell
                cell.gestureDelegate = self
                let circularSliderViewModel = CircularSliderTableViewCellViewModel(grade: viewModel.grade ?? 0.0)
                if shouldCreateSubscription {
                    circularSliderViewModel.$grade
                        .map { $0 as Float? }
                        .assign(to: \.grade, on: viewModel)
                        .store(in: &gradeSubscriptions)
                    viewModel.$maxGrade
                        .replaceNil(with: 0.0)
                        .assign(to: \.maxGrade, on: circularSliderViewModel)
                        .store(in: &gradeSubscriptions)
                    viewModel.$minGrade
                        .replaceNil(with: 0.0)
                        .assign(to: \.minGrade, on: circularSliderViewModel)
                        .store(in: &gradeSubscriptions)
                }
                cell.configure(with: circularSliderViewModel)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(for: indexPath) as LargeTextFieldTableViewCell
                cell.configure(with: viewModel.name)
                if shouldCreateSubscription {
                    cell.textField.publisher(for: \.text)
                        .assign(to: \.name, on: viewModel)
                        .store(in: &cellSubscriptions)
                }
                return cell
            }
            
        case .fields :
            return createFieldRow(for: indexPath)
        case .delete:
            let deleteButton = UIButton()
            deleteButton.setTitleColor(.systemRed, for: .normal)
            deleteButton.setTitle(ButtonStrings.delete.localized, for: .normal)
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.contentView.addSubview(deleteButton)
            deleteButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body).bold
            deleteButton.anchor
                .height(constant: 50)
//                .edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 16, bottom: -10, right: -16))
                .edgesToSuperview()
                .activate()
            return cell
        }
    }
    
    func createFieldRow(for indexPath: IndexPath) -> UITableViewCell {
        guard let row = FieldRow(rawValue: indexPath.row) else { return UITableViewCell() }
        let shouldCreateSubscription = cellSubscriptions.count <= row.rawValue
        switch row {
        case .minGrade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Float>
            cell.configure(with: GlobalStrings.minGrade.localized, value: viewModel.minGrade, keyboardType: .decimalPad)
            if shouldCreateSubscription {
                cell.$value
                    .assign(to: \.minGrade, on: viewModel)
                    .store(in: &cellSubscriptions)
            }
            return cell
        case .maxGrade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Float>
            cell.configure(with: GlobalStrings.maxGrade.localized, value: viewModel.maxGrade, keyboardType: .decimalPad)
            if shouldCreateSubscription {
                cell.$value
                    .assign(to: \.maxGrade, on: viewModel)
                    .store(in: &cellSubscriptions)
            }
            return cell
        case .percentage:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Float>
            cell.configure(with: AssignmentString.percentage.localized, value: viewModel.percentage, keyboardType: .decimalPad)
            if shouldCreateSubscription {
                cell.$value
                    .assign(to: \.percentage, on: viewModel)
                    .store(in: &cellSubscriptions)
            }
            return cell
        case .deadline:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Date>
            cell.configure(with: AssignmentString.deadline.localized, value: viewModel.deadline)
            if shouldCreateSubscription {
                cell.$value
                    .assign(to: \.deadline, on: viewModel)
                    .store(in: &cellSubscriptions)
            }
            return cell
        }
    }
    
}

extension AssignmentDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        if section == .fields {
            let cell = tableView.cellForRow(at: indexPath)
            if let cell = cell as? DetailTextFieldTableViewCell<Float> {
                cell.textField.becomeFirstResponder()
            } else if let cell = cell as? DetailTextFieldTableViewCell<Date> {
                if traitCollection.userInterfaceIdiom == .pad {
                    showDatePickerPopover(cell)
                } else {
                    cell.textField.becomeFirstResponder()
                }
            }
        }
        
    }
}


extension AssignmentDetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}