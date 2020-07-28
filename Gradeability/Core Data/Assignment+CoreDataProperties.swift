//
//  Assignment+CoreDataProperties.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 7/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Assignment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assignment> {
        return NSFetchRequest<Assignment>(entityName: "Assignment")
    }

    @NSManaged public var deadline: Date?
    @NSManaged public var percentage: Float
    @NSManaged public var eventIdentifier: String?
    @NSManaged public var assignment: Assignment?
    @NSManaged public var assignments: NSSet?
    @NSManaged public var subject: Subject?

}

// MARK: Generated accessors for assignments
extension Assignment {

    @objc(addAssignmentsObject:)
    @NSManaged public func addToAssignments(_ value: Assignment)

    @objc(removeAssignmentsObject:)
    @NSManaged public func removeFromAssignments(_ value: Assignment)

    @objc(addAssignments:)
    @NSManaged public func addToAssignments(_ values: NSSet)

    @objc(removeAssignments:)
    @NSManaged public func removeFromAssignments(_ values: NSSet)

}
