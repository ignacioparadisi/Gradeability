//
//  Assignment+CoreDataClass.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Assignment)
public class Assignment: Gradable {

}

extension Assignment {
    static func ==(lhs: Assignment, rhs: Assignment) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.grade == rhs.grade &&
            lhs.maxGrade == rhs.maxGrade &&
            lhs.minGrade == rhs.minGrade &&
            lhs.subject == rhs.subject &&
            lhs.assignments == rhs.assignments &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.deadline == rhs.deadline &&
            lhs.percentage == rhs.percentage
    }
}
