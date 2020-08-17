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
    var showDeleteAlert: ((Int) -> Void)?
    
    // MARK: Internal Properties
    weak var delegate: TermsViewModelDelegate?
    /// Title for the `UIViewController`.
    var title: String {
        return "Terms"
    }
    var newTermViewModel: TermDetailViewModel {
        return TermDetailViewModel()
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
        let currentAction = UIAction(title: TermStrings.setCurrent.localized, image: UIImage(systemName: "pin")) { [weak self] _ in
            // Set current Term to not be the current
            if let currentTerms = self?.terms.filter({ $0.isCurrent }) {
                for term in currentTerms {
                    term.isCurrent = false
                }
            }
            term.isCurrent = true
            CoreDataManager.shared.saveContext()
            self?.delegate?.didChangeCurrentTerm(term)
        }
        let editAction = UIAction(title: ButtonStrings.edit.localized, image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let attributes: UIAction.Attributes = term.isCurrent ? [.destructive, .disabled] : .destructive
        let deleteAction = UIAction(title: ButtonStrings.delete.localized, image: UIImage(systemName: "trash"), attributes: attributes) { [weak self] _ in
            self?.showDeleteAlert?(indexPath.item)
        }
        if !term.isCurrent {
            rootChildren.append(currentAction)
        }
        
        rootChildren.append(editAction)
        rootChildren.append(deleteAction)
        
        let menu = UIMenu(title: "", children: rootChildren)
        return menu
    }
    
    func deleteItem(at index: Int) {
        let term = terms[index]
        CoreDataManager.shared.delete(term)
        terms.remove(at: index)
        gradables.remove(at: index)
        dataDidChange?()
    }
    
    var gradeCardViewModel: GradesCardCollectionViewCellViewModel? {
        guard !terms.isEmpty else { return nil }
        let gradeCardViewModel = GradeCardViewModel(gradable: terms[0], message: "You are doing great!")
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: gradeCardViewModel)
    }
    
    
}
