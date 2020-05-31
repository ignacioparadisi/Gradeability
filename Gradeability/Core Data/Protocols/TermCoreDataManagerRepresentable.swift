//
//  TermCoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol TermCoreDataManagerRepresentable {
    /// Fetch all terms
    /// - Parameter result: Result with the error or terms fetched
    func fetch(result: @escaping (Result<[Term], Error>) -> Void)
    /// Fetches the current term
    func getCurrent() throws -> Term?
    /// Deletes a term from `CoreData`.
    /// - Parameter term: Term to be deleted.
    func delete(_ term: Term)
}
