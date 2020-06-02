//
//  SubjectCoreDataManager.swift
//  Gradeability
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
    
    func create(term: Term, name: String, maxGrade: Float, minGrade: Float, teacherName: String?) {
        let subject = Subject(context: CoreDataManager.shared.context)
        subject.term = term
        subject.id = UUID()
        subject.name = name
        subject.maxGrade = maxGrade
        subject.minGrade = minGrade
        subject.teacherName = teacherName
        subject.dateCreated = Date()
        CoreDataManagerFactory.createManager.saveContext()
    }
    
    /// Deletes a subject from `CoreData`.
    /// - Parameter subject: Subject to be deleted.
    func delete(_ subject: Subject) {
        CoreDataManagerFactory.createManager.delete(subject)
    }
}
