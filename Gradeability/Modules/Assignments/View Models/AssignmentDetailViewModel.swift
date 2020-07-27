//
//  AssignmentDetailViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

protocol AssignmentDetailViewModelDelegate: class {
    func didSave(_ assignment: Assignment?)
}

class AssignmentDetailViewModel {
    private var assignment: Assignment?
    private var subject: Subject?
    private let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
    weak var delegate: AssignmentDetailViewModelDelegate?
    @Published var name: String?
    @Published var grade: Float?
    @Published var percentage: Float?
    @Published var maxGrade: Float?
    @Published var minGrade: Float?
    @Published var deadline: Date?
    @Published var createEvent: Bool = true
    var isEditing: Bool {
        return assignment != nil
    }
    var isDataChanged: Bool {
        if let assignment = assignment {
            return assignment.name != name ||
                assignment.grade as Float? != grade ||
                assignment.minGrade as Float? != minGrade ||
                assignment.maxGrade as Float? != maxGrade ||
                assignment.deadline != deadline ||
                assignment.percentage as Float? != (percentage ?? 0) / 100
        } else {
            return (name != nil && name != "") ||
                (grade != nil && grade != 0) ||
                minGrade != nil ||
                maxGrade != nil ||
                percentage != nil ||
                deadline != nil
        }
    }
    var deleteTitle: String {
        return String(format: AssignmentString.deleteTitle.localized, assignment?.name ?? "")
    }
    
    init(assignment: Assignment) {
        self.assignment = assignment
        self.name = assignment.name
        self.percentage = assignment.percentage * 100
        self.minGrade = assignment.minGrade
        self.maxGrade = assignment.maxGrade
        self.grade = assignment.grade
        self.deadline = assignment.deadline
        self.subject = assignment.subject
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    func save() {
        guard let name = name,
            let percentage = percentage,
            let minGrade = minGrade,
            let maxGrade = maxGrade else { return }
        var assignment: Assignment?
        if self.assignment != nil {
            assignment = self.assignment
        }
        AssignmentCoreDataManager.shared.save(existingAssignment: assignment, name: name, maxGrade: maxGrade, minGrade: minGrade, grade: grade, deadline: deadline, percentage: percentage / 100, subject: subject)
        delegate?.didSave(nil)
    }
    
    func delete() {
        guard let assignment = assignment else { return }
        AssignmentCoreDataManager.shared.delete(assignment)
    }
}

// MARK: - Validations
extension AssignmentDetailViewModel {
    var isValidName: AnyPublisher<Bool, Never> {
        return $name
            .map { $0 != nil && $0 != "" }
            .eraseToAnyPublisher()
    }
    var isValidGrade: AnyPublisher<Bool?, Never> {
        return $grade
            .map { [weak self] grade in
                guard let grade = grade else { return nil }
                guard let maxGrade = self?.maxGrade else { return nil }
                return grade >= 0 && grade <= maxGrade
            }
            .eraseToAnyPublisher()
    }
    var isValidMinGrade: AnyPublisher<Bool?, Never> {
        return $minGrade
            .map { [weak self] minGrade in
                guard let minGrade = minGrade else { return nil }
                guard let maxGrade = self?.maxGrade else { return nil }
                return minGrade >= 0 && minGrade < maxGrade
            }
            .eraseToAnyPublisher()
    }
    var isValidMaxGrade: AnyPublisher<Bool?, Never> {
        return $maxGrade
            .map { [weak self] maxGrade in
                guard let maxGrade = maxGrade else { return nil }
                guard let minGrade = self?.minGrade else { return nil }
                return maxGrade > minGrade
            }
            .eraseToAnyPublisher()
    }
    var areValidGrades: AnyPublisher<(Bool?, Bool?, Bool?), Never> {
        return Publishers.CombineLatest3(isValidGrade, isValidMinGrade, isValidMaxGrade)
            .eraseToAnyPublisher()
    }
    var isValidPercentage: AnyPublisher<Bool?, Never> {
        return $percentage
            .map { [weak self] percentage in
                guard var percentage = percentage else { return nil }
                if let assignment = self?.assignment {
                    let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(assignment: assignment)
                    percentage = percentage / 100 + accumulatedPercentage
                } else if let subject = self?.subject {
                    let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(subject: subject)
                    percentage = percentage / 100 + accumulatedPercentage
                }
                print(percentage)
                return percentage <= 1
            }
            .eraseToAnyPublisher()
    }
    var isValidDeadline: AnyPublisher<Bool?, Never> {
        return $deadline
            .map {
                if $0 == nil {
                    return nil
                } else {
                    return true
                }
            }
            .eraseToAnyPublisher()
    }
    
    var readyToSubmit: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest4(isValidName, areValidGrades, isValidPercentage, isValidDeadline)
            .map { [weak self] isValidName, areValidGrades, isValidPercentage, isValidDeadline in
                guard let self = self else { return false }
                guard let isValidGrade = areValidGrades.0,
                    let isValidMinGrade = areValidGrades.1,
                    let isValidMaxGrade = areValidGrades.2,
                    let isValidPercentage = isValidPercentage,
                    let isValidDeadline = isValidDeadline else { return false }
                return isValidName && isValidGrade && isValidMinGrade && isValidMaxGrade && isValidPercentage && isValidDeadline && self.isDataChanged
            }
            .eraseToAnyPublisher()
    }
}
