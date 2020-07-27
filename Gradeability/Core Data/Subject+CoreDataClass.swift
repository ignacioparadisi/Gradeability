//
//  Subject+CoreDataClass.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Subject)
public class Subject: Gradable {

}

extension Subject {
    static func ==(lhs: Subject, rhs: Subject) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.grade == rhs.grade &&
            lhs.maxGrade == rhs.maxGrade &&
            lhs.minGrade == rhs.minGrade &&
            lhs.term == rhs.term &&
            lhs.assignments == rhs.assignments &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.teacherName == rhs.teacherName
    }
}
