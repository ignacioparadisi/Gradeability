//
//  SubjectsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    /// Parent Term of the Subjects
    private let term: Term
    /// Subjects to be displayed.
    private var subjects: [Subject] = [] {
        didSet {
            dataDidChange?()
        }
    }
    
    // MARK: Internal Properties
    /// Closure called when `subjects` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Closure called when data loading changes so the UI can be updated.
    var loadingDidChange: ((Bool) -> Void)?
    /// Number of rows for the `UITableView`.
    var numberOfRows: Int {
        return subjects.count
    }
    /// Term's name to be displayed as the `UIViewController` title.
    var title: String {
        return term.name ?? ""
    }
    /// Title for the gradables section
    var sectionTitle: String {
        return "Subjects"
    }
    
    // MARK: Initializers
    init(term: Term) {
        self.term = term
    }
    
    // MARK: Functions
    /// Fetches the Subjects.
    func fetch() {
        do {
            subjects = try CoreDataManager.shared.fetchSubjects(for: term)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let subject = subjects[indexPath.row]
        return GradableCellViewModel(subject: subject)
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> (viewModel: GradableViewModelRepresentable, navigationStyle: NavigationStyle)?  {
        let subject = subjects[indexPath.row]
        let viewModel = AssignmentsViewModel(subject: subject)
        return (viewModel, .detail)
    }
    
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu? {
        return nil
    }
}
