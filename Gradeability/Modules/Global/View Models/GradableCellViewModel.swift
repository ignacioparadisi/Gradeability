//
//  GradableCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class GradableCellViewModel: GradableCellViewModelRepresentable {
    private var gradableName: String = ""
    private var gradableDetail: String = ""
    var name: String {
        return gradableName
    }
    var detail: String {
        return gradableDetail
    }
    
    init(term: Term) {
        gradableName = term.name ?? ""
        gradableDetail = "2020 - 2021"
    }
    
    init(subject: Subject) {
        gradableName = subject.name ?? ""
        gradableDetail = subject.teacherName ?? ""
    }
    
    init(assignment: Assignment) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        gradableName = assignment.name ?? ""
        if let deadline = assignment.deadline {
            gradableDetail = dateFormatter.string(from: deadline)
        }
    }
}
