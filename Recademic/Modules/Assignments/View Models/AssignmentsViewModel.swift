//
//  AssignmentsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

class AssignmentsViewModel: GradableViewModelRepresentable {

    private typealias Sections = AssignmentsViewController.Sections
    
    // MARK: Private Properties
    /// Parent Subject of the Assignments.
    private var subject: Subject?
    /// Assignments to be displayed.
    private var assignments: [Assignment] = []
    var gradables: [GradableCellViewModel] = []
    var showDeleteAlert: ((Int) -> Void)?
    
    
    // MARK: Internal Properties
    /// Closure called when `assignments` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Subject's name to be displayed as the `UIViewController` title.
    var title: String {
        return subject?.name ?? ""
    }
    
    /// View model for `GradesCardTableViewCell`
    var gradeCardViewModel: GradesCardCollectionViewCellViewModel? {
        guard let subject = subject else { return nil }
        let gradeCardViewModel = GradeCardViewModel(gradable: subject, message: "You are doing great!")
        let subjectInformationViewModel = SubjectInformationViewModel(subject: subject)
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: gradeCardViewModel, subjectInformationViewModel: subjectInformationViewModel)
    }
    
    var newAssignmentViewModel: AssignmentDetailViewModel? {
        guard let subject = subject else { return nil }
        let viewModel = AssignmentDetailViewModel(subject: subject)
        viewModel.delegate = self
        return viewModel
    }
    
    // MARK: Initializers
    init(subject: Subject? = nil) {
        self.subject = subject
    }
    
    // MARK: Functions
    /// Fetches the Assignments.
    func fetch() {
        guard let subject = subject else { return }
        AssignmentCoreDataManager.shared.fetch(for: subject) { [weak self] result in
            switch result {
            case .success(let assignments):
                self?.assignments = assignments
                self?.gradables = assignments.map { GradableCellViewModel(assignment: $0) }
//                if assignments.isEmpty {
//                    self?.subject = assignments[0].subject
//                }
                self?.dataDidChange?()
            case .failure:
                break
            }
        }
    }
    
    /// Title for the gradables section
    func title(for section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        switch section {
        case .grade:
            return nil
        case .gradables:
            return AssignmentString.assignments.localized
        }
    }
    
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func gradableViewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let assignment = assignments[indexPath.item]
        return GradableCellViewModel(assignment: assignment)
    }
    
    func viewModelForItemSelected(at indexPath: IndexPath) -> AssignmentDetailViewModel {
        let assignment = assignments[indexPath.item]

        let viewModel = AssignmentDetailViewModel(assignment: assignment)
        viewModel.delegate = self
        return viewModel
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        return nil
    }
    
    /// Contextual menu for selected cell
    /// - Parameter indexPath: Index path of the cell
    /// - Returns: Contextual menu for selected cell
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu? {
        var rootChildren: [UIMenuElement] = []
        let editAction = UIAction(title: ButtonStrings.edit.localized, image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let deleteAction = UIAction(title: ButtonStrings.delete.localized, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.showDeleteAlert?(indexPath.item)
        }
        rootChildren.append(editAction)
        rootChildren.append(deleteAction)
        
        let menu = UIMenu(title: "", children: rootChildren)
        return menu
    }
    
    func positionForCell(at indexPath: IndexPath) -> AssignmentCellPrimaryViewModel.CellPosition {
        let count = assignments.count
        if count == 1 {
            return .only
        }
        if indexPath.item == 0 {
            return .first
        }
        if indexPath.item == count - 1 {
            return .last
        }
        return .middle
    }
    
    
    /// Create a new assignment
    func createAssignment() {
        AssignmentCoreDataManager.shared.createRandom(subject: subject)
    }
    
    /// Deletes an assignment at a specified index
    /// - Parameter index: Index of the assignment to be deleted
    func deleteItem(at index: Int) {
        let assignment = assignments[index]
        AssignmentCoreDataManager.shared.delete(assignment)
        assignments.remove(at: index)
        gradables.remove(at: index)
        dataDidChange?()
        fetch()
    }
    
}

extension AssignmentsViewModel: AssignmentDetailViewModelDelegate {
    func didSave(_ assignment: Assignment?) {
        fetch()
    }
}
