//
//  AssignmentsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    /// Parent Subject of the Assignments.
    private var subject: Subject?
    /// Assignments to be displayed.
    private var assignments: [Assignment] = []
    
    // MARK: Internal Properties
    /// Closure called when `assignments` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Closure called when data loading changes so the UI can be updated.
    var loadingDidChange: ((Bool) -> Void)?
    /// Number of rows for the `UITableView`.
    var numberOfRows: Int {
        return assignments.count
    }
    /// Subject's name to be displayed as the `UIViewController` title.
    var title: String {
        return subject?.name ?? ""
    }
    /// Title for the gradables section
    var sectionTitle: String {
        return "Assignments"
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
                self?.dataDidChange?()
            case .failure:
                break
            }
        }
    }
    
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let assignment = assignments[indexPath.row]
        return GradableCellViewModel(assignment: assignment)
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        return nil
    }
    
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu? {
        let assignment = assignments[indexPath.row]
        var rootChildren: [UIMenuElement] = []
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            CoreDataManager.shared.delete(assignment)
            self.fetch()
        }
        rootChildren.append(editAction)
        rootChildren.append(deleteAction)
        
        let menu = UIMenu(title: "", children: rootChildren)
        return menu
    }
    
    func createAssignment() {
        AssignmentCoreDataManager.shared.createAssignment(name: "Prueba", maxGrade: 20, minGrade: 10, grade: 20, deadline: Date(), percentage: 0.5, subject: subject, assignment: nil, assignments: nil)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let assignment = assignments[indexPath.row]
        CoreDataManager.shared.delete(assignment)
        assignments.remove(at: indexPath.row)
    }
    
}

extension AssignmentsViewModel: SubjectsViewModelDelegate {
    func didFetchSubjects(_ subjects: [Subject]) {
        guard !subjects.isEmpty else { return }
        subject = subjects[0]
        fetch()
    }
}
