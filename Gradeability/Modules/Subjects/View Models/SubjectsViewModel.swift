//
//  SubjectsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class SubjectsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    private let term: Term
    private var subjects: [Subject] = [] {
        didSet {
            dataDidChange?()
        }
    }
    // MARK: Internal Properties
    var dataDidChange: (() -> Void)?
    var errorDidHappen: (() -> Void)?
    var numberOfRows: Int {
        return subjects.count
    }
    var title: String {
        return term.name ?? ""
    }
    
    init(term: Term) {
        self.term = term
    }
    
    func fetch() {
        do {
            subjects = try CoreDataManager.shared.fetchSubjects(for: term)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable {
        let subject = subjects[indexPath.row]
        return GradableCellViewModel(subject: subject)
    }
    
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        let subject = subjects[indexPath.row]
        let viewModel = AssignmentsViewModel(subject: subject)
        return viewModel
    }
    
}
