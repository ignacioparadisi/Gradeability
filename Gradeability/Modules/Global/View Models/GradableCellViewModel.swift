//
//  GradableCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension GradableCellViewModel: Hashable {
    static func == (lhs: GradableCellViewModel, rhs: GradableCellViewModel) -> Bool {
        return lhs.gradable == rhs.gradable
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gradable)
    }
}

class GradableCellViewModel: GradableCellViewModelRepresentable {
    var primaryViewModel: GradableCellPrimaryViewRepresentable {
        if let assignment = gradable as? Assignment {
            if let deadline = assignment.deadline {
                let color: UIColor = deadline < Date() ? .secondaryLabel : .systemBlue
                return AssignmentCellPrimaryViewModel(name: name, detail: detail, accentText: accentText, systemImage: "calendar", gradeRingViewModel: gradeRingViewModel, isFinished: deadline < Date(), iconColor: color)
            }
            return AssignmentCellPrimaryViewModel(name: name, detail: detail, accentText: accentText, systemImage: "calendar", gradeRingViewModel: gradeRingViewModel, isFinished: false)
        }
        return GradableCellPrimaryViewModel(name: name, detail: detail, accentText: accentText, systemImage: "person.crop.circle", gradeRingViewModel: gradeRingViewModel)
    }
    
    var secondaryViewTitle: String? {
        if gradable is Term {
            return TermStrings.daysLeft.localized
        } else if gradable is Subject {
            return SubjectStrings.evaluatedPercentage.localized
        }
        return nil
    }
    
    var secondaryViewProgress: Float? {
        if gradable is Term {
            return 0.3
        } else if gradable is Subject {
            return 0.3
        }
        return nil
    }
    
    var secondaryViewProgressText: String? {
        if gradable is Term {
             return "300 días"
        } else if gradable is Subject {
            return "30%"
        }
        return nil
    }
    
    
    // MARK: Private Properties
    /// Name of the `Term`, `Subject` or `Assignment`.
    private var gradableName: String = ""
    /// For `Terms` it is the start and end year, for `Subjects` it is the Teacher's name and for `Assignments` it is the deadline.
    private var gradableDetail: String = ""
    private var gradable: Gradable
    
    // MARK: Internal Properties
    /// Name to be displayed.
    var name: String {
        return gradableName
    }
    /// Detail to be displayed.
    var detail: String {
        return gradableDetail
    }
    var accentText: String? {
        if let term = gradable as? Term, term.isCurrent {
            return TermStrings.currentTerm.localized.uppercased()
        }
        return nil
    }
    
    var shouldShowSecondaryView: Bool {
        if let term = gradable as? Term, term.isCurrent {
            return true
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            return false
        }
        return gradable is Subject
    }
    var gradeRingViewModel: GradeRingViewModel {
        return GradeRingViewModel(gradable: gradable)
    }
    
    // MARK: Initializers
    /// Initialized `GradableCellViewModel` with a `Term`. This means `name` is the Term's name and `detail` is the start and end year of the `Term`.
    /// - Parameter term: Term to be displayed.
    init(term: Term) {
        gradable = term
        gradableName = term.name ?? ""
        gradableDetail = "2020 - 2021"
    }
    
    /// Initialized `GradableCellViewModel` with a `Subject`. This means `name` is the Subject's name and `detail` is the Teacher's name.
    /// - Parameter subject: Subject to be displayed.
    init(subject: Subject) {
        gradable = subject
        gradableName = subject.name ?? ""
        gradableDetail = subject.teacherName ?? ""
    }
    
    /// Initialized `GradableCellViewModel` with an `Assignment`. This means `name` is the Assignment's name and `detail` is the Assignment's deadline.
    /// - Parameter assignment: Assignment to be displayed.
    init(assignment: Assignment) {
        gradable = assignment
        let dateFormatter: DateFormatter = .longDateShortTimeDateFormatter
        gradableName = assignment.name ?? ""
        if let deadline = assignment.deadline {
            gradableDetail = dateFormatter.string(from: deadline)
        }
    }

}
