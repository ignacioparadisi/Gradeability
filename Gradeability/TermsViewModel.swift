//
//  TermsViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class TermsViewModel {
    // MARK: Private Properties
    private var terms: [Term] = [] {
        didSet {
            dataDidChange?()
        }
    }
    // MARK: Internal Properties
    var dataDidChange: (() -> Void)?
    var errorDidHappen: (() -> Void)?
    var numberOfRows: Int {
        return terms.count
    }
    
    func fetch() {
        do {
            terms = try CoreDataManager.shared.fetchTerms()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func textForRow(at indexPath: IndexPath) -> String? {
        let term = terms[indexPath.row]
        return term.name
    }
}
