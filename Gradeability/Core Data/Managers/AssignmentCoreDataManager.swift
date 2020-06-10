//
//  AssignmentCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class AssignmentCoreDataManager: AssignmentCoreDataManagerRepresentable {
    
    static var shared: AssignmentCoreDataManager  = AssignmentCoreDataManager()
    
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
            try CoreDataManagerFactory.createManager.context.execute(asyncFetchRequest)
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
        let assignment = Assignment(context: CoreDataManagerFactory.createManager.context)
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
        CoreDataManagerFactory.createManager.saveContext()
        
        calculateGrade(for: subject)
    }
    
    func calculateGrade(for subject: Subject?) {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Assignment")
        fetchRequest.resultType = .dictionaryResultType
        let predicate = NSPredicate(format: "%K == %@" , #keyPath(Assignment.subject.id), subject!.id! as CVarArg)
        fetchRequest.predicate = predicate
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "grade"
        let multiplyExpression = NSExpression(forFunction: "multiply:by:",
                     arguments: [
                        NSExpression(forKeyPath: #keyPath(Assignment.grade)),
                        NSExpression(forKeyPath: #keyPath(Assignment.percentage))
                    ])
        expressionDescription.expression = multiplyExpression
        expressionDescription.expressionResultType = .integer32AttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try CoreDataManagerFactory.createManager.context.fetch(fetchRequest)
            var grade: Float = 0
            for result in results {
                grade += result["grade"] as! Float
            }
            subject?.grade = grade
            CoreDataManagerFactory.createManager.saveContext()
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
    }
    
    /// Deletes an assignment from `CoreData`.
    /// - Parameter assignment: Assignment to be deleted.
    func delete(_ assignment: Assignment) {
        CoreDataManagerFactory.createManager.delete(assignment)
    }
}
