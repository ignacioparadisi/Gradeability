//
//  SubjectStrings.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum SubjectStrings: String, Localizable {
    var tableName: String {
        return "Subject"
    }
    // MARK: Cases
    case subjects
    case evaluatedPercentage
    case noSubjectSelectedTitle
    case noSubjectSelectedMessage
    case teacher
    case classroom
    case deleteTitle
    case deleteMessage
    case emptySubjects
    case createSubject
    case newSubject
}
