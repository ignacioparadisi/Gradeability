//
//  AssignmentCoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol AssignmentCoreDataManagerRepresentable {
    func fetch(for subject: Subject) throws -> [Assignment]
     func createAssignment(id: UUID?, name: String?, grade: Float?, maxGrade: Float, minGrade: Float, deadline: Date?, percentage: Float, subject: Subject?, assignment: Assignment?, assignments: NSSet?, dateCreated: Date?)
    func delete(_ assignment: Assignment)
}
