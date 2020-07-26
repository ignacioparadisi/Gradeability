//
//  AssignmentDetailViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/25/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import Combine

class AssignmentDetailViewModel {
    private let assignment: Assignment
    @Published var name: String?
    @Published var grade: String?
    @Published var percentage: String?
    @Published var maxGrade: String?
    @Published var minGrade: String?
    @Published var deadline: String?
    var gradeCardViewModel: GradesCardCollectionViewCellRepresentable {
        let cardViewModel = GradeCardViewModel(gradable: assignment, message: "You are doing great!")
        return GradesCardCollectionViewCellViewModel(gradeCardViewModel: cardViewModel)
    }
    var gradeCardViewModel2: GradeCardViewModel {
        return GradeCardViewModel(gradable: assignment, message: "")
    }
    
    var combineGrades: AnyPublisher<(Float, Float, Float, Float)?, Never> {
        return Publishers.CombineLatest4($minGrade, $maxGrade, $grade, $percentage)
            .map { [weak self] minGrade, maxGrade, grade, percentage in
                guard let self = self else { return nil }
                // Check if all fields are filled
                guard let minGradeStr = minGrade,
                    let maxGradeStr = maxGrade,
                    let gradeStr = grade,
                    let percentageStr = percentage else {
                        return nil
                        
                }
                // Check if all fields are Float
                guard let minGrade = Float(minGradeStr),
                    let maxGrade = Float(maxGradeStr),
                    let grade = Float(gradeStr),
                    var percentage = Float(percentageStr) else {
                        return nil
                }
                if minGrade >= maxGrade || grade < 0 || grade > maxGrade { return nil }
                let accumulatedPercentage = SubjectCoreDataManager.shared.getAccumulatedPercentage(assignment: self.assignment)
                percentage = percentage / 100
                if accumulatedPercentage + percentage > 1 { return nil }
                return (minGrade, maxGrade, grade, percentage)
            }
            .eraseToAnyPublisher()
    }
//    private var combineLast: AnyPublisher<(String?, String?, String?)?, Never> {
//        return Publishers.CombineLatest($name, $deadline)
//    }
//
//    private var readyToSubmit: AnyPublisher<(Bool, Bool)?, Never> {
//
//    }
    
    init(_ assignment: Assignment) {
        self.assignment = assignment
        self.name = assignment.name
        self.percentage = "\(assignment.percentage * 100)"
        self.minGrade = "\(assignment.minGrade)"
        self.maxGrade = "\(assignment.maxGrade)"
        self.grade = "\(grade)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        if let deadline = assignment.deadline {
            self.deadline = dateFormatter.string(from: deadline)
        }
    }
    
    func save() {
        
    }
}
