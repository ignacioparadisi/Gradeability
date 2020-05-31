//
//  SubjectsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol SubjectsViewModelDelegate: class {
    func didFetchSubjects(_ subjects: [Subject])
}

class SubjectsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    /// Parent Term of the Subjects
    private var term: Term?
    /// Subjects to be displayed.
    private var subjects: [Subject] = []
    weak var delegate: SubjectsViewModelDelegate?
    
    // MARK: Internal Properties
    var isMasterController: Bool = true
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
        return term?.name ?? "Subjects"
    }
    /// Title for the gradables section
    var sectionTitle: String {
        return "Subjects"
    }
    var termsViewModel: TermsViewModel {
        let viewModel = TermsViewModel()
        viewModel.delegate = self
        return viewModel
    }
    
    // MARK: Initializers
    init(term: Term? = nil) {
        self.term = term
    }
    
    // MARK: Functions
    /// Fetches the Subjects.
    func fetch() {
        guard let term = term else { return }
        CoreDataFactory.createSubjectManager.fetch(for: term) { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.subjects = subjects
                self?.dataDidChange?()
                self?.delegate?.didFetchSubjects(subjects)
            case .failure:
                break
            }
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
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable?  {
        let subject = subjects[indexPath.row]
        let viewModel = AssignmentsViewModel(subject: subject)
        return viewModel
        
    }
    
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu? {
        let subject = subjects[indexPath.row]
        var rootChildren: [UIMenuElement] = []
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
            
        }
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
            CoreDataManager.shared.delete(subject)
            self.fetch()
        }
        rootChildren.append(editAction)
        rootChildren.append(deleteAction)
        
        let menu = UIMenu(title: "", children: rootChildren)
        return menu
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let subject = subjects[indexPath.row]
        CoreDataManager.shared.delete(subject)
        subjects.remove(at: indexPath.row)
    }
    
}

// MARK: - TermsViewModelDelegate
extension SubjectsViewModel: TermsViewModelDelegate {
    func didChangeCurrentTerm(_ term: Term) {
        self.term = term
        fetch()
    }
}
