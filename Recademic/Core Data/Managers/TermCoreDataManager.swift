//
//  TermCoreDataManager.swift
//  Recademic
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
            try CoreDataManagerFactory.createManager.context.execute(asyncFetchRequest)
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
            return try CoreDataManagerFactory.createManager.context.fetch(fetchRequest).first
        } catch {
            return nil
        }
        
    }
    
    func create(name: String, maxGrade: Float, minGrade: Float) {
        let term = Term(context: CoreDataManagerFactory.createManager.context)
        if getCurrent() == nil {
            term.isCurrent = true
        }
        term.id = UUID()
        term.name = name
        term.maxGrade = maxGrade
        term.minGrade = minGrade
        term.dateCreated = Date()
        CoreDataManagerFactory.createManager.saveContext()
    }
    
    /// Deletes a term from `CoreData`.
    /// - Parameter term: Term to be deleted.
    func delete(_ term: Term) {
        CoreDataManagerFactory.createManager.delete(term)
    }
    
    // TODO: Delete this method
    func createRandom() {
        create(name: "Semestre", maxGrade: 10, minGrade: 20)
    }
}
