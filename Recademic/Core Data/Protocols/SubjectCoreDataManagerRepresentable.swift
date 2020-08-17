//
//  SubjectCoreDataManagerRepresentable.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol SubjectCoreDataManagerRepresentable {
    /// Fetches all subjects for a term.
    /// - Parameters:
    ///   - term: Term where the assignments belong.
    ///   - result: Result with the error or subjects fetched
    func fetch(for term: Term, result: @escaping (Result<[Subject], Error>) -> Void)
    func save(existingSubject: Subject?, name: String?, maxGrade: Float, minGrade: Float, teacherName: String, term: Term?) -> Subject
    /// Deletes a subject from `CoreData`
    /// - Parameter subject: Subject to be deleted
    func delete(_ subject: Subject)
}
