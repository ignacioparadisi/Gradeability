//
//  TestSubjectCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/31/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class TestSubjectCoreDataManager: SubjectCoreDataManagerRepresentable {
    
    static var shared: TestSubjectCoreDataManager  = TestSubjectCoreDataManager()
    
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
            try TestCoreDataManager.shared.context.execute(asyncFetchRequest)
        } catch {
            result(.failure(error))
        }
    }
    
    func create(term: Term, name: String, maxGrade: Float, minGrade: Float, teacherName: String?) {
        let subject = Subject(context: TestCoreDataManager.shared.context)
        subject.term = term
        subject.id = UUID()
        subject.name = name
        subject.maxGrade = maxGrade
        subject.minGrade = minGrade
        subject.teacherName = teacherName
        subject.dateCreated = Date()
        TestCoreDataManager.shared.saveContext()
        
        calculateGrade(for: term)
    }
    
    func calculateGrade(for term: Term?) {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@" , #keyPath(Subject.term.id), term!.id! as CVarArg)
        fetchRequest.predicate = predicate
          
        do {
            let subjects = try TestCoreDataManager.shared.context.fetch(fetchRequest)
            let grade: Float = subjects.map({ $0.grade }).reduce(0.0, +) / Float(subjects.count)
            term?.grade = grade
            TestCoreDataManager.shared.saveContext()
        } catch let error as NSError {
            print("count not fetched \(error), \(error.userInfo)")
        }
    }
    
    /// Deletes a subject from `CoreData`.
    /// - Parameter subject: Subject to be deleted.
    func delete(_ subject: Subject) {
        TestCoreDataManager.shared.delete(subject)
    }
}
