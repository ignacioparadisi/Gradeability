//
//  TermCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class TermCoreDataManager: CoreDataManager, TermCoreDataManagerRepresentable {
    
    override class var shared: TermCoreDataManager {
        struct Singleton {
            static let instance = TermCoreDataManager()
        }
        return Singleton.instance
    }
    
    override private init() {}
    
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
            try context.execute(asyncFetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Fetches the current term
    func getCurrent() throws -> Term? {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Term.isCurrent), NSNumber(value: true))
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    /// Deletes a term from `CoreData`.
    /// - Parameter term: Term to be deleted.
    func delete(_ term: Term) {
        super.delete(term)
    }
}
