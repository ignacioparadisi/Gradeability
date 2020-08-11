//
//  CoreDataFactory.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CoreDataManagerFactory {
    private static var isTesting: Bool {
        return true
    }
    /// Returns the respective `TermCoreDataManager` depending if it's testing or not
    static var createTermManager: TermCoreDataManagerRepresentable {
        if isTesting {
            return TestTermCoreDataManager.shared
        }
        return TermCoreDataManager.shared
    }
    /// Returns the respective `SubjectCoreDataManager` depending if it's testing or not
    static var createSubjectManager: SubjectCoreDataManagerRepresentable {
        if isTesting {
            return TestSubjectCoreDataManager.shared
        }
        return SubjectCoreDataManager.shared
    }
    /// Returns the respective `AssignmentCoreDataManager` depending if it's testing or not
    static var createAssignmentManager: AssignmentCoreDataManagerRepresentable {
        if isTesting {
            return TestAssignmentCoreDataManager.shared
        }
        return AssignmentCoreDataManager.shared
    }
}
