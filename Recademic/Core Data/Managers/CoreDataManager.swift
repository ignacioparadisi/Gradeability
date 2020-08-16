//
//  CoreDataManager.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: CoreDataManagerRepresentable {
    
    /// Singleton instance of `CoreDataManager`.
    static var shared: CoreDataManager = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Recademic")
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // - MARK: Import Dummy JSON
    // TODO: Delete this method later
    func importTermsFromJSON() {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        let count = try! context.count(for: fetchRequest)
        
        guard count == 0 else { return }
        
        let results = try! context.fetch(fetchRequest)
        results.forEach { context.delete($0) }
        saveContext()
        
        let jsonURL = Bundle.main.url(forResource: "DummyTerms", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        
        let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments]) as! [[String: Any]]
        
        for jsonDictionary in jsonArray {
            let term = Term(context: context)
            term.id = UUID()
            term.name = jsonDictionary["name"] as? String
            term.grade = jsonDictionary["grade"] as! Float
            term.maxGrade = jsonDictionary["maxGrade"] as! Float
            term.minGrade = jsonDictionary["minGrade"] as! Float
            term.isCurrent = jsonDictionary["isCurrent"] as! Bool
            term.dateCreated = Date()
            
            let subjectsArray = jsonDictionary["subjects"] as! [[String: Any]]
            for subjectDictionary in subjectsArray {
                let subject = Subject(context: context)
                subject.id = UUID()
                subject.term = term
                subject.name = subjectDictionary["name"] as? String
                subject.grade = subjectDictionary["grade"] as! Float
                subject.maxGrade = subjectDictionary["maxGrade"] as! Float
                subject.minGrade = subjectDictionary["minGrade"] as! Float
                if let teacherName = subjectDictionary["teacherName"] as? String {
                    subject.teacherName = teacherName
                }
                
                let assignmentsArray = subjectDictionary["assignments"] as! [[String: Any]]
                for assignmentDictionary in assignmentsArray {
                    let assignment = Assignment(context: context)
                    assignment.id = UUID()
                    assignment.subject = subject
                    assignment.name = assignmentDictionary["name"] as? String
                    assignment.grade = assignmentDictionary["grade"] as! Float
                    assignment.maxGrade = assignmentDictionary["maxGrade"] as! Float
                    assignment.minGrade = assignmentDictionary["minGrade"] as! Float
                    let percentage = assignmentDictionary["percentage"] as! NSNumber
                    assignment.percentage = Float(truncating: percentage)
                    assignment.deadline = Date()
                }
            }
        }
        saveContext()
    }
    
    /// Deletes an object from Core Data
    /// - Parameter object: Object to be deleted
    func delete(_ object: Gradable) {
        context.delete(object)
        saveContext()
    }

}
