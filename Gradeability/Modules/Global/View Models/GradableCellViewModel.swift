//
//  GradableCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradableCellViewModel: GradableCellViewModelRepresentable {
    // MARK: Private Properties
    /// Name of the `Term`, `Subject` or `Assignment`.
    private var gradableName: String = ""
    /// For `Terms` it is the start and end year, for `Subjects` it is the Teacher's name and for `Assignments` it is the deadline.
    private var gradableDetail: String = ""
    /// Accessory Type to be displayed on the cell
    private var gradableAccessoryType: UITableViewCell.AccessoryType = .disclosureIndicator
    
    // MARK: Internal Properties
    /// Name to be displayed.
    var name: String {
        return gradableName
    }
    /// Detail to be displayed.
    var detail: String {
        return gradableDetail
    }
    /// Accessory Type top be displaced on the cell
    var accessoryType: UITableViewCell.AccessoryType {
        return gradableAccessoryType
    }
    
    // MARK: Initializers
    /// Initialized `GradableCellViewModel` with a `Term`. This means `name` is the Term's name and `detail` is the start and end year of the `Term`.
    /// - Parameter term: Term to be displayed.
    init(term: Term) {
        gradableName = term.name ?? ""
        gradableDetail = "2020 - 2021"
        gradableAccessoryType = term.isCurrent ? .checkmark : .disclosureIndicator
    }
    
    /// Initialized `GradableCellViewModel` with a `Subject`. This means `name` is the Subject's name and `detail` is the Teacher's name.
    /// - Parameter subject: Subject to be displayed.
    init(subject: Subject) {
        gradableName = subject.name ?? ""
        gradableDetail = subject.teacherName ?? ""
    }
    
    /// Initialized `GradableCellViewModel` with an `Assignment`. This means `name` is the Assignment's name and `detail` is the Assignment's deadline.
    /// - Parameter assignment: Assignment to be displayed.
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
