//
//  AssignmentCellPrimaryViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

struct AssignmentCellPrimaryViewModel: GradableCellPrimaryViewRepresentable {
    enum CellPosition {
        case first
        case middle
        case last
        case only
    }
    var name: String
    var detail: String?
    var accentText: String?
    var systemImage: String?
    var gradeRingViewModel: GradeRingViewModel
    var isFinished: Bool
    var iconColor: UIColor = .secondaryLabel
    
    init(name: String, detail: String, accentText: String? = nil, systemImage: String? = nil, gradeRingViewModel: GradeRingViewModel, isFinished: Bool, iconColor: UIColor = .secondaryLabel) {
        self.name = name
        self.detail = detail
        self.accentText = accentText
        self.systemImage = systemImage
        self.gradeRingViewModel = gradeRingViewModel
        self.isFinished = isFinished
        self.iconColor = iconColor
    }
}
