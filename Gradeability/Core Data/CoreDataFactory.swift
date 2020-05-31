//
//  CoreDataFactory.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CoreDataFactory {
    /// Returns the respective `TermCoreDataManager` depending if it's testing or not
    static var createTermManager: TermCoreDataManagerRepresentable {
        return TermCoreDataManager.shared
    }
    /// Returns the respective `SubjectCoreDataManager` depending if it's testing or not
    static var createSubjectManager: SubjectCoreDataManagerRepresentable {
        return SubjectCoreDataManager.shared
    }
    /// Returns the respective `AssignmentCoreDataManager` depending if it's testing or not
    static var createAssignmentManager: AssignmentCoreDataManagerRepresentable {
        return AssignmentCoreDataManager.shared
    }
}
