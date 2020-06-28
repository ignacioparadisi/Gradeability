//
//  AssignmentsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentsViewModel: GradableViewModelRepresentable {

    private typealias Sections = AssignmentsViewController.Sections
    
    // MARK: Private Properties
    /// Parent Subject of the Assignments.
    private var subject: Subject?
    /// Assignments to be displayed.
    private var assignments: [Assignment] = []
    var gradables: [GradableCellViewModel] = []
    
    // MARK: Internal Properties
    /// Closure called when `assignments` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    var numberOfSections: Int {
        return Sections.allCases.count
    }
    /// Subject's name to be displayed as the `UIViewController` title.
    var title: String {
        return subject?.name ?? ""
    }
    
    /// View model for `GradesCardTableViewCell`
    var gradeCardViewModel: GradesCardCollectionViewCellViewModel? {
        guard let subject = subject else { return nil }
        let gradeCardViewModel = GradeCardViewModel(gradable: subject, type: GlobalStrings.grade.localized, message: "You are doing great!")
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: gradeCardViewModel)
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
                self?.dataDidChange?()
            case .failure:
                break
            }
        }
    }
    
    /// Get number of rows for a specific section of the table view
    /// - Parameter section: Section where the number of rows belong
    /// - Returns: The number of rows for the section
    func numberOfRows(in section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .grade:
            return 1
        case .gradables:
            return assignments.count
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
        let assignment = assignments[indexPath.row]
        return GradableCellViewModel(assignment: assignment)
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
        let assignment = assignments[indexPath.row]
        var rootChildren: [UIMenuElement] = []
        let editAction = UIAction(title: ButtonStrings.edit.localized, image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let deleteAction = UIAction(title: ButtonStrings.delete.localized, image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            CoreDataManager.shared.delete(assignment)
            self.fetch()
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
        AssignmentCoreDataManager.shared.createAssignment(name: "Prueba", maxGrade: 20, minGrade: 10, grade: 20, deadline: Date(), percentage: 0.5, subject: subject, assignment: nil, assignments: nil)
    }
    
    /// Delete assignment
    func deleteItem(at indexPath: IndexPath) {
        let assignment = assignments[indexPath.row]
        CoreDataManager.shared.delete(assignment)
        assignments.remove(at: indexPath.row)
    }
    
}
