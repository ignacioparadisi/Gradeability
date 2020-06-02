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
    var persistentContainer: NSPersistentCloudKitContainer { get set }
    var context: NSManagedObjectContext { get }
    func saveContext ()
    func delete(_ object: Gradable)
}
