//
//  TestAssignmentCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/31/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class TestAssignmentCoreDataManager: AssignmentCoreDataManagerRepresentable {
    
    static var shared: TestAssignmentCoreDataManager  = TestAssignmentCoreDataManager()
    
    private init() {}
    
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
            try TestCoreDataManager.shared.context.execute(asyncFetchRequest)
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
    func createAssignment(name: String?, maxGrade: Float, minGrade: Float, grade: Float = 0, deadline: Date?, percentage: Float, subject: Subject?, assignment: Assignment? = nil, assignments: NSSet? = nil) {
        let assignment = Assignment(context: TestCoreDataManager.shared.context)
        assignment.id = UUID()
        assignment.subject = subject
        assignment.name = name
        assignment.grade = grade
        assignment.maxGrade = maxGrade
        assignment.minGrade = minGrade
        assignment.percentage = percentage
        assignment.deadline = deadline
        assignment.assignment = assignment
        assignment.assignments = assignments
        assignment.dateCreated = Date()
        TestCoreDataManager.shared.saveContext()
    }
    
    /// Deletes an assignment from `CoreData`.
    /// - Parameter assignment: Assignment to be deleted.
    func delete(_ assignment: Assignment) {
        TestCoreDataManager.shared.delete(assignment)
    }
}
