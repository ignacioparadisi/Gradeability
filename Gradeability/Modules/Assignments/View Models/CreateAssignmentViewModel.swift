//
//  CreateAssignmentViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class CreateAssignmentViewModel {
    var name: String?
    var grade: Float = 0.0
    var maxGrade: Float?
    var minGrade: Float?
    var percentage: Float?
    var deadline: Date?
    var shouldSaveEventInCalendar: Bool = true
}
