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
    private var terms: [Term] = []
    var gradables: [GradableCellViewModel] = []
    var dataDidChange: (() -> Void)?
    
    // MARK: Internal Properties
    weak var delegate: TermsViewModelDelegate?
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
                self?.gradables = terms.map { GradableCellViewModel(term: $0) }
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
            return "Terms"
        }
    }
    
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        let term = terms[indexPath.item]
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
            self?.deleteItem(at: indexPath)
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
        let term = terms[indexPath.item]
        CoreDataManager.shared.delete(term)
        terms.remove(at: indexPath.item)
        gradables.remove(at: indexPath.item)
        dataDidChange?()
    }
    
    var gradeCardViewModel: GradesCardCollectionViewCellViewModel? {
        guard !terms.isEmpty else { return nil }
        let gradeCardViewModel = GradeCardViewModel(gradable: terms[0], type: "Grade", message: "You are doing great!")
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: gradeCardViewModel)
    }
    
    
}
