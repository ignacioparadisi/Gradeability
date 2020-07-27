//
//  Term+CoreDataClass.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Term)
public class Term: Gradable {
    
}

extension Term {
    static func ==(lhs: Term, rhs: Term) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.minGrade == rhs.minGrade &&
            lhs.maxGrade == rhs.maxGrade &&
            lhs.grade == rhs.grade &&
            lhs.isCurrent == rhs.isCurrent &&
            lhs.subjects == rhs.subjects &&
            lhs.dateCreated == rhs.dateCreated
    }
}
