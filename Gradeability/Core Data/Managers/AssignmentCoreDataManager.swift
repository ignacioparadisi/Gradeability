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
    
    /// Fetches all assignments for a subject.
    /// - Parameters:
    ///   - subject: Subject where the assignments belong.
    ///   - result: Result with the error or assignments fetched
    func fetch(for subject: Subject, result: @escaping (Result<[Assignment], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Assignment> = Assignment.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Assignment.subject.id), subject.id! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Assignment.dateCreated), ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        let asyncFetchRequest: NSAsynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchResult in
            DispatchQueue.main.async {
                if let assignments = fetchResult.finalResult {
                    result(.success(assignments))
                }
            }
        }
        do {
            try context.execute(asyncFetchRequest)
        } catch {
            result(.failure(error))
        }
    }
    
    /// Creates a new assignment and saves it in CoreData.
    /// - Parameters:
    ///   - id: ID for the assignment (In case the assignment already exists).
    ///   - name: Name for the assignment.
    ///   - grade: Grade for the assignment.
    ///   - maxGrade: Maximum grade for the assignment.
    ///   - minGrade: Minimum grade for the assignment.
    ///   - deadline: Deadline for the assignment.
    ///   - percentage: Percentage for the assignment.
    ///   - subject: Subject where the assignment belongs.
    ///   - assignment: Parent assignment.
    ///   - assignments: Children assignments.
    ///   - dateCreated: Date when the assignment was created (in case the assignment already exists).
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
    
    /// Deletes an assignment from `CoreData`.
    /// - Parameter assignment: Assignment to be deleted.
    func delete(_ assignment: Assignment) {
        super.delete(assignment)
    }
}
