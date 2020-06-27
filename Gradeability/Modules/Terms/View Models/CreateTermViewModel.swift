//
//  CreateTermViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CreateTermViewModel {
    var name: String? = "" {
        didSet {
            checkFieldsValues()
        }
    }
    var maxGrade: Float? = 0.0 {
        didSet {
            checkFieldsValues()
        }
    }
    var minGrade: Float? = 0.0 {
        didSet {
            checkFieldsValues()
        }
    }

    @Published private(set) var canSave: Bool = false
    
    private func checkFieldsValues() {
        guard let minGrade = minGrade, let maxGrade = maxGrade, let name = name else {
            canSave = false
            return
        }
        if minGrade > maxGrade {
            canSave = false
            return
        }
        if name != "" && maxGrade < 0.0 {
            canSave = false
            return
        }
        canSave = true
    }
}
