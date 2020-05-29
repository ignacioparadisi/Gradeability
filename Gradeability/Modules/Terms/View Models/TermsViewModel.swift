//
//  TermsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class TermsViewModel: GradableViewModelRepresentable {
    
    // MARK: Private Properties
    /// Terms to be displayed.
    private var terms: [Term] = [] {
        didSet {
            dataDidChange?()
        }
    }
    
    // MARK: Internal Properties
    /// Closure called when `terms` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Number of rows for the `UITableView`.
    var numberOfRows: Int {
        return terms.count
    }
    /// Title for the `UIViewController`.
    var title: String {
        return "Terms"
    }
    /// Title for the gradables section
    var sectionTitle: String {
        return "Terms"
    }
    
    // MARK: Functions
    /// Fetches the Subjects.
    func fetch() {
        do {
            terms = try CoreDataManager.shared.fetchTerms()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let term = terms[indexPath.row]
        return GradableCellViewModel(term: term)
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> (viewModel: GradableViewModelRepresentable, navigationStyle: NavigationStyle)? {
        let term = terms[indexPath.row]
        let viewModel = SubjectsViewModel(term: term)
        return (viewModel, .push)
    }
    
}
