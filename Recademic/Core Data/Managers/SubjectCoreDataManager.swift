//
//  SubjectCoreDataManager.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class SubjectCoreDataManager: SubjectCoreDataManagerRepresentable {
    
    static var shared: SubjectCoreDataManager  = SubjectCoreDataManager()
    
    private init() {}
    
    /// Fetches all subjects for a term.
    /// - Parameters:
    ///   - term: Term where the assignments belong.
    ///   - result: Result with the error or subjects fetched.
    func fetch(for term: Term, result: @escaping (Result<[Subject], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Subject.term.id), term.id! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Assignment.dateCreated), ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        let asyncFetchRequest: NSAsynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchResult in
            DispatchQueue.main.async {
                if let subjects = fetchResult.finalResult {
                    result(.success(subjects))
                }
            }
        }
        do {
            try CoreDataManagerFactory.createManager.context.execute(asyncFetchRequest)
        } catch {
            result(.failure(error))
        }
    }
    
    func save(existingSubject: Subject? = nil, name: String?, maxGrade: Float, minGrade: Float, teacherName: String, term: Term?) -> Subject {
        var subject: Subject!
        if existingSubject != nil {
            subject = existingSubject
        } else {
            subject = Subject(context: CoreDataManagerFactory.createManager.context)
            subject.term = term
            subject.dateCreated = Date()
        }
        subject.id = UUID()
        subject.name = name
        subject.teacherName = teacherName
        subject.minGrade = minGrade
        subject.maxGrade = maxGrade
        CoreDataManagerFactory.createManager.saveContext()
        return subject
        // TODO: Calculate Term grade
    }
    
    /// Deletes a subject from `CoreData`.
    /// - Parameter subject: Subject to be deleted.
    func delete(_ subject: Subject) {
        CoreDataManagerFactory.createManager.delete(subject)
    }
    
    func getAccumulatedPercentage(assignment: Assignment) -> Float {
        guard let subject = assignment.subject else { return 0.0 }
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Assignment")
        fetchRequest.resultType = .dictionaryResultType
        let predicate = NSPredicate(format: "%K == %@ AND %K != %@" , #keyPath(Assignment.subject.id), subject.id! as CVarArg, #keyPath(Assignment.id), assignment.id! as CVarArg)
        fetchRequest.predicate = predicate
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "percentage"
        let multiplyExpression = NSExpression(forFunction: "sum:",
                     arguments: [
                        NSExpression(forKeyPath: #keyPath(Assignment.percentage))
                    ])
        expressionDescription.expression = multiplyExpression
        expressionDescription.expressionResultType = .floatAttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try CoreDataManagerFactory.createManager.context.fetch(fetchRequest)
            if results.isEmpty { return 0.0 }
            guard let percentage = results[0].value(forKey: "percentage") as? NSNumber else {
                return 0.0
            }
            return percentage.floatValue
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
        return 0.0
    }
    
    func getAccumulatedPercentage(subject: Subject) -> Float {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Assignment")
        fetchRequest.resultType = .dictionaryResultType
        let predicate = NSPredicate(format: "%K == %@" , #keyPath(Assignment.subject.id), subject.id! as CVarArg)
        fetchRequest.predicate = predicate
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "percentage"
        let multiplyExpression = NSExpression(forFunction: "sum:",
                     arguments: [
                        NSExpression(forKeyPath: #keyPath(Assignment.percentage))
                    ])
        expressionDescription.expression = multiplyExpression
        expressionDescription.expressionResultType = .floatAttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try CoreDataManagerFactory.createManager.context.fetch(fetchRequest)
            if results.isEmpty { return 0.0 }
            guard let percentage = results[0].value(forKey: "percentage") as? NSNumber else {
                return 0.0
            }
            return percentage.floatValue
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
        return 0.0
    }
    
    func getEvaluatedPercentage(subject: Subject) -> Float {
        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: "Assignment")
        fetchRequest.resultType = .dictionaryResultType
        let predicate = NSPredicate(format: "%K == %@ AND %K < %@" , #keyPath(Assignment.subject.id), subject.id! as CVarArg, #keyPath(Assignment.deadline), Date() as NSDate)
        fetchRequest.predicate = predicate
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "percentage"
        let multiplyExpression = NSExpression(forFunction: "sum:",
                     arguments: [
                        NSExpression(forKeyPath: #keyPath(Assignment.percentage))
                    ])
        expressionDescription.expression = multiplyExpression
        expressionDescription.expressionResultType = .floatAttributeType
        fetchRequest.propertiesToFetch = [expressionDescription]
        
        do {
            let results = try CoreDataManagerFactory.createManager.context.fetch(fetchRequest)
            if results.isEmpty { return 0.0 }
            guard let percentage = results[0].value(forKey: "percentage") as? NSNumber else {
                return 0.0
            }
            return percentage.floatValue
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
        return 0.0
    }
}
