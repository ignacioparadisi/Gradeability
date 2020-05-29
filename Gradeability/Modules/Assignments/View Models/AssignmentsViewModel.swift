//
//  AssignmentsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class AssignmentsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    /// Parent Subject of the Assignments.
    private let subject: Subject
    /// Assignments to be displayed.
    private var assignments: [Assignment] = [] {
        didSet {
            dataDidChange?()
        }
    }
    
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
        return subject.name ?? ""
    }
    /// Title for the gradables section
    var sectionTitle: String {
        return "Assignments"
    }
    
    // MARK: Initializers
    init(subject: Subject) {
        self.subject = subject
    }
    
    // MARK: Functions
    /// Fetches the Assignments.
    func fetch() {
        do {
            assignments = try CoreDataManager.shared.fetchAssignments(for: subject)
        } catch {
            print(error.localizedDescription)
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
    func nextViewModelForRow(at indexPath: IndexPath) -> (viewModel: GradableViewModelRepresentable, navigationStyle: NavigationStyle)? {
        return nil
    }
    
}
