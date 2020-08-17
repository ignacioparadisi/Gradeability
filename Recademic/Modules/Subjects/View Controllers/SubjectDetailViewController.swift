//
//  SubjectDetailViewController.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 8/16/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class SubjectDetailViewController: UIViewController {
    private enum Section: Int, CaseIterable {
        case title
        case grades
        case teacher
        case delete
    }
    private enum GradeRow: Int, CaseIterable {
        case grade
        case minGrade
        case maxGrade
    }
    // MARK: Properties
    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private var cancelButton: UIBarButtonItem!
    private let viewModel: SubjectDetailViewModel
    private var saveButton: UIBarButtonItem!
    private var subscriptions = Set<AnyCancellable>()
    private var cellSubscriptions = Set<AnyCancellable>()
    private var gradeSubscriptions = Set<AnyCancellable>()
    
    // MARK: Initializers
    init(_ viewModel: SubjectDetailViewModel) {
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
        navigationController?.presentationController?.delegate = self
        setupNavigationBar()
        setupTableView()
        setupViewModel()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.anchor.edgesToSuperview().activate()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.register(CircularSliderTableViewCell.self)
        tableView.register(LargeTextFieldTableViewCell.self)
        tableView.register(DetailTextFieldTableViewCell<Float>.self)
        tableView.register(DetailTextFieldTableViewCell<String>.self)
        tableView.register(SwitchTableViewCell.self)
    }
    
    func setupViewModel() {
        if viewModel.isEditing {
            viewModel.$name
                .receive(on: RunLoop.main)
                .assign(to: \.title, on: self)
                .store(in: &subscriptions)
        } else {
            title = AssignmentString.createAssignment.localized
        }
        
        viewModel.readyToSubmit
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: saveButton)
            .store(in: &subscriptions)
    }
    
    func setupNavigationBar() {
        cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showDiscardChangesAlert(_:)))
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(save))
        navigationItem.setRightBarButton(saveButton, animated: false)
        navigationItem.setLeftBarButton(cancelButton, animated: false)
    }
    
    @objc private func save() {
        viewModel.save()
        dismiss(animated: true)
    }
    
    @objc private func showDiscardChangesAlert(_ sender: UIBarButtonItem) {
        if viewModel.isDataChanged {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let dismissAction = UIAlertAction(title: "Discard Changes", style: .destructive) { [weak self] _ in
                self?.dismiss(animated: true)
            }
            let cancelAction = UIAlertAction(title: ButtonStrings.cancel.localized, style: .cancel)
            alertController.addAction(dismissAction)
            alertController.addAction(cancelAction)
            if let popoverController = alertController.popoverPresentationController {
                popoverController.barButtonItem = cancelButton
            }
            present(alertController, animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    private func showDeleteAlert() {
        let alertController = UIAlertController(title: viewModel.deleteTitle, message: AssignmentString.deleteMessage.localized, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: ButtonStrings.cancel.localized, style: .cancel)
        let deleteAction = UIAlertAction(title: ButtonStrings.delete.localized, style: .destructive) { [weak self] _ in
            self?.viewModel.delete()
            self?.dismiss(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true)
    }
    
    
}

// MARK: - UITableViewDataSource
extension SubjectDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Don't show the delete button if it's not editing
        return viewModel.isEditing ? Section.allCases.count : Section.allCases.count - 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .title:
            return 1
        case .grades:
            return GradeRow.allCases.count
        case .teacher:
            return 1
        case .delete:
            return viewModel.isEditing ? 1 : 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .title:
            let cell = tableView.dequeueReusableCell(for: indexPath) as LargeTextFieldTableViewCell
            cell.configure(with: viewModel.name, placeholder: GlobalStrings.name.localized)
            cell.textField.publisher(for: \.text)
                .assign(to: \.name, on: viewModel)
                .store(in: &cellSubscriptions)
            return cell
        case .grades :
            return createGradeRow(for: indexPath)
        case .teacher:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<String>
            cell.configure(with: "Nombre del Profesor", value: viewModel.teacherName)
            cell.textField.publisher(for: \.text)
                .assign(to: \.teacherName, on: viewModel)
                .store(in: &cellSubscriptions)
            viewModel.isValidTeacherName
                .map { $0 as Bool? }
                .assign(to: \.isValid, on: cell)
                .store(in: &cellSubscriptions)
            return cell
        case .delete:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.textColor = .systemRed
            cell.textLabel?.text = ButtonStrings.delete.localized
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func createGradeRow(for indexPath: IndexPath) -> UITableViewCell {
        guard let row = GradeRow(rawValue: indexPath.row) else { return UITableViewCell() }
        switch row {
        case .grade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as CircularSliderTableViewCell
            cell.gestureDelegate = self
            let circularSliderViewModel = CircularSliderTableViewCellViewModel(grade: viewModel.grade)
            viewModel.$maxGrade
                .replaceNil(with: 0.0)
                .assign(to: \.maxGrade, on: circularSliderViewModel)
                .store(in: &gradeSubscriptions)
            viewModel.$minGrade
                .replaceNil(with: 0.0)
                .assign(to: \.minGrade, on: circularSliderViewModel)
                .store(in: &gradeSubscriptions)
            cell.isUserInteractionEnabled = false
            cell.configure(with: circularSliderViewModel)
            return cell
        case .minGrade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Float>
            cell.configure(with: GlobalStrings.minGrade.localized, value: viewModel.minGrade, keyboardType: .decimalPad)
            cell.$value
                .assign(to: \.minGrade, on: viewModel)
                .store(in: &cellSubscriptions)
            viewModel.areValidGrades
                .map { isValidMinGrade, _ in
                    return isValidMinGrade
                }
                .assign(to: \.isValid, on: cell)
                .store(in: &subscriptions)
            return cell
        case .maxGrade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as DetailTextFieldTableViewCell<Float>
            cell.configure(with: GlobalStrings.maxGrade.localized, value: viewModel.maxGrade, keyboardType: .decimalPad)
            cell.$value
                .assign(to: \.maxGrade, on: viewModel)
                .store(in: &cellSubscriptions)
            viewModel.areValidGrades
                .map { _, isValidMaxGrade in
                    return isValidMaxGrade
            }
            .assign(to: \.isValid, on: cell)
            .store(in: &subscriptions)
            return cell
        }
    }
}

extension SubjectDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .grades:
            let cell = tableView.cellForRow(at: indexPath)
            if let cell = cell as? DetailTextFieldTableViewCell<Float> {
                cell.textField.becomeFirstResponder()
            } else if let cell = cell as? DetailTextFieldTableViewCell<String> {
                cell.textField.becomeFirstResponder()
            }
        case .delete:
            showDeleteAlert()
        default:
            break
        }
        
    }
}

extension SubjectDetailViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        showDiscardChangesAlert(cancelButton)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return !viewModel.isDataChanged
    }
}


extension SubjectDetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

