//
//  AssignmentStrings.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum AssignmentString: String, Localizable {
    var tableName: String {
        return "Assignment"
    }
    // MARK: Localizable keys
    case assignments
    case createAssignment
    case emptyAssignments
    case insertName
    case assignmentsName
}
