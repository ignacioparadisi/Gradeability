//
//  TermsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import Combine

protocol TermsViewModelDelegate: class {
    func didChangeCurrentTerm(_ term: Term)
}

class TermsViewModel: GradableViewModelRepresentable {
    
    private typealias Sections = TermsViewController.Sections
    
    // MARK: Private Properties
    /// Terms to be displayed.
    private var terms: [Term] = [] {
        didSet {
            guard !terms.isEmpty else { return }
            gradables = terms.map { GradableCellViewModel(term: $0) }
        }
    }
    @Published var gradables: [GradableCellViewModel] = []
    
    // MARK: Internal Properties
    weak var delegate: TermsViewModelDelegate?
    /// Closure called when `terms` changes so the UI can be updated.
    var dataDidChange: (() -> Void)?
    /// Closure called when data loading changes so the UI can be updated.
    var loadingDidChange: ((Bool) -> Void)?
    var numberOfSections: Int {
        return Sections.allCases.count
    }
    /// Title for the `UIViewController`.
    var title: String {
        return "Terms"
    }
    // MARK: Functions
    /// Fetches the Subjects.
    func fetch() {
        TermCoreDataManager.shared.fetch { [weak self] result in
            switch result {
            case .success(let terms):
                self?.terms = terms
            case .failure:
                break
            }
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .grade:
            return 0
        case .gradables:
            return terms.count
        }
    }
    
    /// Title for the gradables section
    func title(for section: Int) -> String? {
        guard let section = Sections(rawValue: section) else { return nil }
        switch section {
        case .grade:
            return nil
        case .gradables:
            return "Terms"
        }
    }
    
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func gradableViewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let term = terms[indexPath.row]
        return GradableCellViewModel(term: term)
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        let term = terms[indexPath.row]
        let viewModel = SubjectsViewModel(term: term)
        viewModel.isMasterController = false
        return viewModel
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
            self?.delegate?.didChangeCurrentTerm(term)
        }
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let attributes: UIAction.Attributes = term.isCurrent ? [.destructive, .disabled] : .destructive
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: attributes) { [weak self] _ in
            CoreDataManager.shared.delete(term)
            self?.terms.remove(at: indexPath.item)
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
