//
//  AssignmentCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class AssignmentCoreDataManager: CoreDataManager, AssignmentCoreDataManagerRepresentable {
    override class var shared: AssignmentCoreDataManager {
        struct Singleton {
            static let instance = AssignmentCoreDataManager()
        }
        return Singleton.instance
    }
    
    override private init() {}
    
    func fetch(for subject: Subject) throws -> [Assignment] {
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Assignment.subject.id), subject.id! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Assignment.dateCreated), ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try context.fetch(fetchRequest)
    }
    
    func createAssignment(id: UUID?, name: String?, grade: Float?, maxGrade: Float, minGrade: Float, deadline: Date?, percentage: Float, subject: Subject?, assignment: Assignment?, assignments: NSSet?, dateCreated: Date?) {
        let newAssignment = Assignment(context: context)
        if let id = id {
            newAssignment.id = id
        } else {
            newAssignment.id = UUID()
        }
        newAssignment.subject = subject
        newAssignment.name = name
        if let grade = grade {
            newAssignment.grade = grade
        }
        newAssignment.maxGrade = maxGrade
        newAssignment.minGrade = minGrade
        newAssignment.percentage = percentage
        newAssignment.deadline = deadline
        newAssignment.assignment = assignment
        newAssignment.assignments = assignments
        newAssignment.dateCreated = dateCreated
        
        saveContext()
    }
    
    func delete(_ assignment: Assignment) {
        super.delete(assignment)
    }
}
