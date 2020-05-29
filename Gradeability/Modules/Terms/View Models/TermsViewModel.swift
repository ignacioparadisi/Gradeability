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
    private var terms: [Term] = [] {
        didSet {
            dataDidChange?()
        }
    }
    // MARK: Internal Properties
    var dataDidChange: (() -> Void)?
    var errorDidHappen: (() -> Void)?
    var numberOfRows: Int {
        return terms.count
    }
    var title: String {
        return "Terms"
    }
    
    func fetch() {
        do {
            terms = try CoreDataManager.shared.fetchTerms()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let term = terms[indexPath.row]
        return GradableCellViewModel(term: term)
    }
    
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        let term = terms[indexPath.row]
        let viewModel = SubjectsViewModel(term: term)
        return viewModel
    }
    
}
