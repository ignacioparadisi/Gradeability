//
//  SubjectDetailViewModel.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 8/16/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

protocol SubjectDetailViewModelDelegate: class {
    func didSave(_ subject: Subject?)
}

class SubjectDetailViewModel {
    
    // MARK: Properties
    
    /// Assignment to show the details.
    private var subject: Subject?
    /// Subject where the assignment belongs.
    private var term: Term?
    /// Delegate to handler deletion and saving.
    weak var delegate: SubjectDetailViewModelDelegate?
    /// Name for the assignment.
    @Published var name: String?
    /// Percentage for the assignment.
    @Published var teacherName: String?
    /// Maximum grade for the assignment.
    @Published var maxGrade: Float?
    /// Minimum grade for the assignment.
    @Published var minGrade: Float?
    var grade: Float {
        return subject?.grade ?? 0.0
    }
    /// Whether the user is editing an existing assignment or creating a new one.
    private(set) var isEditing: Bool = false
    /// Whether data has been changed or not.
    var isDataChanged: Bool {
        if let subject = subject {
            return subject.name != name ||
                subject.minGrade as Float? != minGrade ||
                subject.maxGrade as Float? != maxGrade ||
                subject.teacherName != teacherName
        } else {
            return (name != nil && name != "") ||
                (teacherName != nil && teacherName != "") ||
                minGrade != nil ||
                maxGrade != nil
        }
    }
    /// Title for delete alert.
    var deleteTitle: String {
        return String(format: AssignmentString.deleteTitle.localized, subject?.name ?? "")
    }
    
    // MARK: Initializers
    
    init(subject: Subject) {
        self.subject = subject
        self.teacherName = subject.teacherName
        self.name = subject.name
        self.minGrade = subject.minGrade
        self.maxGrade = subject.maxGrade
        self.term = subject.term
        self.isEditing = true
    }
    
    init(term: Term?) {
        self.term = term
        self.isEditing = false
    }
    
    // MARK: Functions
    
    /// Updates or creates an assignments in `CoreData`.
    func save() {
        guard let name = name,
            let teacherName = teacherName,
            let minGrade = minGrade,
            let maxGrade = maxGrade else { return }
        var subject: Subject?
        if self.subject != nil {
            subject = self.subject
        }
        self.subject = SubjectCoreDataManager.shared.save(existingSubject: subject, name: name, maxGrade: maxGrade, minGrade: minGrade, teacherName: teacherName, term: term)
        delegate?.didSave(subject)
    }
    
    /// Delete assignment from CoreData.
    func delete() {
        guard let subject = subject else { return }
        SubjectCoreDataManager.shared.delete(subject)
    }
}

// MARK: - Validations
extension SubjectDetailViewModel {
    /// Defines if the name textfield is valid.
    var isValidName: AnyPublisher<Bool, Never> {
        return $name
            .map { $0 != nil && $0 != "" }
            .eraseToAnyPublisher()
    }
    /// Defines if grade textfield is valid.
    var isValidTeacherName: AnyPublisher<Bool, Never> {
        return $teacherName
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
        return Publishers.CombineLatest3(isValidName, isValidTeacherName, areValidGrades)
            .map { [weak self] isValidName, isValidTeacherName, areValidGrades in
                guard let self = self else { return false }
                guard let isValidMinGrade = areValidGrades.0,
                    let isValidMaxGrade = areValidGrades.1 else { return false }
                return isValidName && isValidTeacherName && isValidMinGrade && isValidMaxGrade && self.isDataChanged
            }
            .eraseToAnyPublisher()
    }
}
