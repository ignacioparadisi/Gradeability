//
//  TermCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class TermCoreDataManager: TermCoreDataManagerRepresentable {
    
    static var shared: TermCoreDataManager  = TermCoreDataManager()
    
    private init() {}
    
    /// Fetch all terms
    /// - Parameter result: Result with the error or terms fetched
    func fetch(result: @escaping (Result<[Term], Error>) -> Void) {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Term.dateCreated), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let asyncFetchRequest: NSAsynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { fetchResult in
            DispatchQueue.main.async {
                if let terms = fetchResult.finalResult {
                    result(.success(terms))
                }
            }
        }
        do {
            try CoreDataManager.shared.context.execute(asyncFetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Fetches the current term
    func getCurrent() -> Term? {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Term.isCurrent), NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            return try CoreDataManager.shared.context.fetch(fetchRequest).first
        } catch {
            return nil
        }
        
    }
    
    func create(name: String, maxGrade: Float, minGrade: Float) {
        let term = Term(context: CoreDataManager.shared.context)
        if getCurrent() == nil {
            term.isCurrent = true
        }
        term.id = UUID()
        term.name = name
        term.maxGrade = maxGrade
        term.minGrade = minGrade
        term.dateCreated = Date()
        CoreDataManager.shared.saveContext()
    }
    
    /// Deletes a term from `CoreData`.
    /// - Parameter term: Term to be deleted.
    func delete(_ term: Term) {
        CoreDataManager.shared.delete(term)
    }
}
