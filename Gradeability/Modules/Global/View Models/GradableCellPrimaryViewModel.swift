//
//  GradableCellPrimaryViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

struct GradableCellPrimaryViewModel: GradableCellPrimaryViewRepresentable {
    var name: String
    var detail: String?
    var accentText: String?
    var systemImage: String?
    var gradeRingViewModel: GradeRingViewModel
    
    init(name: String, detail: String, accentText: String? = nil, systemImage: String? = nil, gradeRingViewModel: GradeRingViewModel) {
        self.name = name
        self.detail = detail
        self.accentText = accentText
        self.systemImage = systemImage
        self.gradeRingViewModel = gradeRingViewModel
    }
}
