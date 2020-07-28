//
//  SubjectsViewModel.swift
//  Gradeability WatchKit App Extension
//
//  Created by Ignacio Paradisi on 7/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class SubjectsViewModel {
    
    var term: Term?
    var subjects: [Subject] = []
    
    func fetch() {
        guard let term = TermCoreDataManager.shared.getCurrent() else { return }
        SubjectCoreDataManager.shared.fetch(for: term) { [weak self] result in
            switch result {
            case .success(let subjects):
                self?.subjects = subjects
            case .failure:
                break
            }
        }
    }
    
    init() {
        fetch()
    }
}
