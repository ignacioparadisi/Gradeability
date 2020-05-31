//
//  TermCoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol TermCoreDataManagerRepresentable {
    func fetch(result: @escaping (Result<[Term], Error>) -> Void)
    func getCurrent() throws -> Term?
    func delete(_ term: Term)
}
