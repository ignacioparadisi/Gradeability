//
//  TermStrings.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum TermStrings: String, Localizable {
    var tableName: String {
        return "Term"
    }
    // MARK: Cases
    case daysLeft
    case currentTerm
    case createTerm
    case getStartedMessage
    case deleteTitle
    case deleteMessage
    case newTerm
    case setCurrent
}
