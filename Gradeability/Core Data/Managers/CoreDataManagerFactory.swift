//
//  CoreDataManagerFactory.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CoreDataManagerFactory {
    /// Defines wether test cases are running or not.
    private static var isTesting: Bool {
        return false
    }
    /// Returns the respective `CoreDataManager` depending if it's testing or not.
    static var createManager: CoreDataManagerRepresentable {
        if isTesting {
            return TestCoreDataManager.shared
        }
        return CoreDataManager.shared
    }
}
