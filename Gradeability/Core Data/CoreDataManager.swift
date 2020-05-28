//
//  CoreDataManager.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    /// `CoreDataManager` instance of the Singleton
    static var shared: CoreDataManager = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentCloudKitContainer(name: "Gradeability")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // - MARK: Import Dummy JSON
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
            let name = jsonDictionary["name"] as? String
            let grade = jsonDictionary["grade"] as! Float
            let maxGrade = jsonDictionary["maxGrade"] as! Float
            let minGrade = jsonDictionary["minGrade"] as! Float
            let isCurrent = jsonDictionary["isCurrent"] as! Bool
            
            
            let term = Term(context: context)
            term.name = name
            term.grade = grade
            term.maxGrade = maxGrade
            term.minGrade = minGrade
            term.isCurrent = isCurrent
            term.dateCreated = Date()
        }
        saveContext()
    }
    
    // - MARK: Terms
    func fetchTerms() throws -> [Term] {
        let fetchRequest: NSFetchRequest<Term> = Term.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: #keyPath(Term.dateCreated), ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try context.fetch(fetchRequest)
    }
    

}
