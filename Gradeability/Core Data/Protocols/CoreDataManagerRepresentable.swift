//
//  CoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataManagerRepresentable {
    /// Persistent Container for Core Data.
    var persistentContainer: NSPersistentCloudKitContainer { get set }
    /// Context of Core Data.
    var context: NSManagedObjectContext { get }
    /// Saves the data into Core Data.
    func saveContext ()
    /// Deletes a gradable from CoreData.
    /// - Parameter object: Gradable to be deleted.
    func delete(_ object: Gradable)
}
