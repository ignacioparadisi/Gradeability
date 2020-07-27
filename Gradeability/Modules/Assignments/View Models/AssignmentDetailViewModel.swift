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
    func didSave(_ assignment: Assignment)
}

class AssignmentDetailViewModel {
    private let assignment: Assignment
    private let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
    weak var delegate: AssignmentDetailViewModelDelegate?
    @Published var name: String?
    @Published var grade: Float?
    @Published var percentage: Float?
    @Published var maxGrade: Float?
    @Published var minGrade: Float?
    @Published var deadline: Date?
    @Published var createEvent: Bool = true
    var gradeCardViewModel: GradesCardCollectionViewCellRepresentable {
        let cardViewModel = GradeCardViewModel(gradable: assignment, message: "You are doing great!")
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: cardViewModel)
    }
    
    // MARK: Field Validations
    var validateName: AnyPublisher<Bool, Never> {
        return $name
            .map { $0 != nil && $0 != "" }
            .eraseToAnyPublisher()
    }
    
    // TODO: Revisar estas variables
    var combineGrades: AnyPublisher<(Float, Float, Float, Float)?, Never> {
        return Publishers.CombineLatest4($minGrade, $maxGrade, $grade, $percentage)
            .map { [weak self] minGrade, maxGrade, grade, percentage in
                guard let self = self else { return nil }
                // Check if all fields are filled
                guard let minGrade = minGrade,
                    let maxGrade = maxGrade,
                    let grade = grade,
                    var percentage = percentage else {
                        return nil
                        
                }
                if grade == self.assignment.grade &&
                    minGrade == self.assignment.minGrade &&
                    maxGrade == self.assignment.maxGrade &&
                    percentage == self.assignment.percentage { return nil }
                if minGrade >= maxGrade || grade < 0 || grade > maxGrade { return nil }
                let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(assignment: self.assignment)
                percentage = percentage / 100
                if accumulatedPercentage + percentage > 1 { return nil }
                return (minGrade, maxGrade, grade, percentage)
            }
            .eraseToAnyPublisher()
    }
    private var combineLast: AnyPublisher<(String, Date)?, Never> {
        return Publishers.CombineLatest($name, $deadline)
            .map { [weak self] name, deadline in
                guard let name = name, !name.isEmpty , let deadline = deadline else { return nil }
                if name == self?.assignment.name && deadline == self?.assignment.deadline { return nil }
                return (name, deadline)
            }
            .eraseToAnyPublisher()
    }

    var readyToSubmit: AnyPublisher<(Bool, Bool)?, Never> {
        return Publishers.CombineLatest(combineGrades, combineLast)
            .map { combineGrades, combineLast in
                if combineGrades == nil || combineLast == nil { return nil }
                return (true, true)
            }
            .eraseToAnyPublisher()
    }
    
    init(_ assignment: Assignment) {
        self.assignment = assignment
        self.name = assignment.name
        self.percentage = assignment.percentage * 100
        self.minGrade = assignment.minGrade
        self.maxGrade = assignment.maxGrade
        self.grade = assignment.grade
        self.deadline = assignment.deadline
    }
    
    func save() {
        guard let name = name,
            let percentage = percentage,
            let minGrade = minGrade,
            let maxGrade = maxGrade else { return }
        
        assignment.name = name
        assignment.percentage = percentage / 100
        assignment.minGrade = minGrade
        assignment.maxGrade = maxGrade
        assignment.grade = grade ?? 0
        assignment.deadline = deadline
        CoreDataManagerFactory.createManager.saveContext()
        delegate?.didSave(assignment)
    }
}
