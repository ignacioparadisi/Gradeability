//
//  AssignmentCoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol AssignmentCoreDataManagerRepresentable {
    /// Fetches all assignments for a subject.
    /// - Parameters:
    ///   - subject: Subject where the assignments belong.
    ///   - result: Result with the error or assignments fetched
    func fetch(for subject: Subject, result: @escaping (Result<[Assignment], Error>) -> Void)
    /// Creates a new assignment and saves it in CoreData.
    /// - Parameters:
    ///   - id: ID for the assignment (In case the assignment already exists).
    ///   - name: Name for the assignment.
    ///   - grade: Grade for the assignment.
    ///   - maxGrade: Maximum grade for the assignment.
    ///   - minGrade: Minimum grade for the assignment.
    ///   - deadline: Deadline for the assignment.
    ///   - percentage: Percentage for the assignment.
    ///   - subject: Subject where the assignment belongs.
    ///   - assignment: Parent assignment.
    ///   - assignments: Children assignments.
    ///   - dateCreated: Date when the assignment was created (in case the assignment already exists).
    func createAssignment(id: UUID?, name: String?, grade: Float?, maxGrade: Float, minGrade: Float, deadline: Date?, percentage: Float, subject: Subject?, assignment: Assignment?, assignments: NSSet?, dateCreated: Date?)
    /// Deletes an assignment from `CoreData`.
    /// - Parameter assignment: Assignment to be deleted.
    func delete(_ assignment: Assignment)
}
