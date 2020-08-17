//
//  TermDetailViewModel.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 8/17/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

protocol TermDetailViewModelDelegate: class {
    func didSave(_ term: Term?)
}

class TermDetailViewModel {
    // MARK: Properties
       
       /// Assignment to show the details.
       private var term: Term?
       /// Delegate to handler deletion and saving.
       weak var delegate: TermDetailViewModelDelegate?
       /// Name for the assignment.
       @Published var name: String?
       /// Maximum grade for the assignment.
       @Published var maxGrade: Float?
       /// Minimum grade for the assignment.
       @Published var minGrade: Float?
       var grade: Float {
           return term?.grade ?? 0.0
       }
       /// Whether the user is editing an existing assignment or creating a new one.
       private(set) var isEditing: Bool = false
       /// Whether data has been changed or not.
       var isDataChanged: Bool {
           if let term = term {
               return term.name != name ||
                   term.minGrade as Float? != minGrade ||
                   term.maxGrade as Float? != maxGrade
           } else {
               return (name != nil && name != "") ||
                   minGrade != nil ||
                   maxGrade != nil
           }
       }
       /// Title for delete alert.
       var deleteTitle: String {
           return String(format: AssignmentString.deleteTitle.localized, term?.name ?? "")
       }
       
       // MARK: Initializers
       
       init(term: Term? = nil) {
           
        if let term = term {
            self.term = term
            self.name = term.name
            self.minGrade = term.minGrade
            self.maxGrade = term.maxGrade
            self.isEditing = true
        } else {
            isEditing = false
        }
       }
       
       // MARK: Functions
       
       /// Updates or creates an assignments in `CoreData`.
       func save() {
           guard let name = name,
               let minGrade = minGrade,
               let maxGrade = maxGrade else { return }
           var term: Term?
           if self.term != nil {
               term = self.term
           }
        self.term = TermCoreDataManager.shared.save(existingTerm: term, name: name, maxGrade: maxGrade, minGrade: minGrade)
           delegate?.didSave(term)
       }
       
       /// Delete assignment from CoreData.
       func delete() {
           guard let term = term else { return }
           TermCoreDataManager.shared.delete(term)
       }
}

// MARK: - Validations
extension TermDetailViewModel {
    /// Defines if the name textfield is valid.
    var isValidName: AnyPublisher<Bool, Never> {
        return $name
            .map { $0 != nil && $0 != "" }
            .eraseToAnyPublisher()
    }
    /// Defines if minGrade textfield is valid.
    var isValidMinGrade: AnyPublisher<Bool?, Never> {
        return $minGrade
            .map { [weak self] minGrade in
                guard let minGrade = minGrade else { return nil }
                guard let maxGrade = self?.maxGrade else { return nil }
                return minGrade >= 0 && minGrade < maxGrade
            }
            .eraseToAnyPublisher()
    }
    /// Defines if maxGrade textfield is valid.
    var isValidMaxGrade: AnyPublisher<Bool?, Never> {
        return $maxGrade
            .map { [weak self] maxGrade in
                guard let maxGrade = maxGrade else { return nil }
                guard let minGrade = self?.minGrade else { return nil }
                return maxGrade > minGrade
            }
            .eraseToAnyPublisher()
    }
    /// Defines if all grade textfields are valid.
    var areValidGrades: AnyPublisher<(Bool?, Bool?), Never> {
        return Publishers.CombineLatest(isValidMinGrade, isValidMaxGrade)
            .eraseToAnyPublisher()
    }
    /// Defines if all fields are valid.
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isValidName, areValidGrades)
            .map { [weak self] isValidName, areValidGrades in
                guard let self = self else { return false }
                guard let isValidMinGrade = areValidGrades.0,
                    let isValidMaxGrade = areValidGrades.1 else { return false }
                return isValidName && isValidMinGrade && isValidMaxGrade && self.isDataChanged
            }
            .eraseToAnyPublisher()
    }
}

