//
//  AssignmentCoreDataManager.swift
//  Recademic
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
    func save(existingAssignment: Assignment? = nil, name: String?, maxGrade: Float, minGrade: Float, grade: Float? = 0, deadline: Date?, percentage: Float, subject: Subject?, parentAssignment: Assignment? = nil, assignments: NSSet? = nil) -> Assignment {
        var assignment: Assignment!
        if existingAssignment != nil {
            assignment = existingAssignment
        } else {
           assignment = Assignment(context: CoreDataManagerFactory.createManager.context)
            assignment.subject = subject
            assignment.dateCreated = Date()
            assignment.assignment = parentAssignment
        }
        assignment.id = UUID()
        assignment.name = name
        assignment.grade = grade ?? 0
        assignment.maxGrade = maxGrade
        assignment.minGrade = minGrade
        assignment.percentage = percentage
        assignment.deadline = deadline
        assignment.assignments = assignments
        CoreDataManagerFactory.createManager.saveContext()
        calculateGrade(for: subject)
        return assignment
    }
    
    /// Calculates the grade for a subject depending on its assignments, assigns the grade and saves the context.
    /// - Parameter subject: Subject to which the grade should be calculated
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
        expressionDescription.expressionResultType = .floatAttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try CoreDataManagerFactory.createManager.context.fetch(fetchRequest)
            var grade: Float = 0
            for result in results {
                if let number = result.value(forKey: "grade") as? NSNumber {
                    grade += number.floatValue
                }
            }
            print(results)
            subject?.grade = grade
            CoreDataManagerFactory.createManager.saveContext()
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
    }
    
    /// Deletes an assignment from `CoreData`.
    /// - Parameter assignment: Assignment to be deleted.
    func delete(_ assignment: Assignment) {
        let subject = assignment.subject
        CoreDataManagerFactory.createManager.delete(assignment)
        calculateGrade(for: subject)
    }
    
    func createRandom(subject: Subject?) {
        let randomGrade = Float.random(in: 0..<20)
        print(randomGrade)
        _ = save(name: "Prueba", maxGrade: 20, minGrade: 10, grade: randomGrade, deadline: Date(), percentage: 0.1, subject: subject)
    }
}
