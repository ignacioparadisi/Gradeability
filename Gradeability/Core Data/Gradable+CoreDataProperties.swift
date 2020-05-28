//
//  Gradable+CoreDataProperties.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//
//

import Foundation
import CoreData


extension Gradable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gradable> {
        return NSFetchRequest<Gradable>(entityName: "Gradable")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var grade: Float
    @NSManaged public var maxGrade: Float
    @NSManaged public var minGrade: Float
    @NSManaged public var name: String?
    @NSManaged public var id: UUID?

}
