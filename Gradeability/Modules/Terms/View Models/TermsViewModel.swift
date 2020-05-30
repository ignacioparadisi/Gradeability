//
//  TermsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol TermsViewModelDelegate: class {
    func didChangeCurrentTerm(_ term: Term)
}

class TermsViewModel: GradableViewModelRepresentable {
    
    // MARK: Private Properties
    /// Terms to be displayed.
    private var terms: [Term] = []
    private var isLoading: Bool = false {
        didSet {
            loadingDidChange?(isLoading)
        }
    }
    
    // MARK: Internal Properties
    weak var delegate: TermsViewModelDelegate?
    /// Closure called when `terms` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Closure called when data loading changes so the UI can be updated.
    var loadingDidChange: ((Bool) -> Void)?
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
        if isLoading { return }
        isLoading = true
        CoreDataManager.shared.fetchTerms { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let terms):
                self?.terms = terms
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
        let term = terms[indexPath.row]
        return GradableCellViewModel(term: term)
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> (viewModel: GradableViewModelRepresentable, navigationStyle: NavigationStyle)? {
        let term = terms[indexPath.row]
        let viewModel = SubjectsViewModel(term: term)
        viewModel.isMasterController = false
        return (viewModel, .push)
    }
    
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu? {
        // Get the new current Term
        let term = terms[indexPath.row]
        var rootChildren: [UIMenuElement] = []
        let currentAction = UIAction(title: "Set Current", image: UIImage(systemName: "pin")) { [weak self] _ in
            // Set current Term to not be the current
            let currentTerm = self?.terms.filter { $0.isCurrent }.first
            currentTerm?.isCurrent = false
            term.isCurrent = true
            CoreDataManager.shared.saveContext()
            self?.dataDidChange?()
            self?.delegate?.didChangeCurrentTerm(term)
        }
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let attributes: UIAction.Attributes = term.isCurrent ? [.destructive, .disabled] : .destructive
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: attributes) { _ in
            CoreDataManager.shared.delete(term)
            self.fetch()
        }
        if !term.isCurrent {
            rootChildren.append(currentAction)
        }
        
        rootChildren.append(editAction)
        rootChildren.append(deleteAction)
        
        let menu = UIMenu(title: "", children: rootChildren)
        return menu
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let term = terms[indexPath.row]
        CoreDataManager.shared.delete(term)
        terms.remove(at: indexPath.row)
    }
    
    
}
