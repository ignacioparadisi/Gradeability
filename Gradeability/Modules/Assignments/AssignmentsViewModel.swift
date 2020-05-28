//
//  AssignmentsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class AssignmentsViewModel: GradableViewModelRepresentable {

    // MARK: Private Properties
    private let subject: Subject
    private var assignments: [Assignment] = [] {
        didSet {
            dataDidChange?()
        }
    }
    // MARK: Internal Properties
    var dataDidChange: (() -> Void)?
    var errorDidHappen: (() -> Void)?
    var numberOfRows: Int {
        return assignments.count
    }
    var title: String {
        return subject.name ?? ""
    }
    
    init(subject: Subject) {
        self.subject = subject
    }
    
    func fetch() {
        do {
            assignments = try CoreDataManager.shared.fetchAssignments(for: subject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func textForRow(at indexPath: IndexPath) -> String? {
        let subject = assignments[indexPath.row]
        return subject.name
    }
    
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable? {
        return nil
    }
    
}
