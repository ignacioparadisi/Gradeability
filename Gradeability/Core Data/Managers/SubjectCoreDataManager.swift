//
//  SubjectCoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class SubjectCoreDataManager: CoreDataManager, SubjectCoreDataManagerRepresentable {
    
    override class var shared: SubjectCoreDataManager {
        struct Singleton {
            static let instance = SubjectCoreDataManager()
        }
        return Singleton.instance
    }
    
    private override init() {}
    
    func fetch(for term: Term) throws -> [Subject] {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        let predicate: NSPredicate = NSPredicate(format: "%K == %@", #keyPath(Subject.term.id), term.id! as CVarArg)
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Subject.dateCreated), ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try context.fetch(fetchRequest)
    }
    
    func delete(_ subject: Subject) {
        super.delete(subject)
    }
}
