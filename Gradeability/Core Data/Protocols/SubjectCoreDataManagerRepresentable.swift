//
//  SubjectCoreDataManagerRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol SubjectCoreDataManagerRepresentable {
    func fetch(for term: Term) throws -> [Subject]
    func delete(_ subject: Subject)
}
