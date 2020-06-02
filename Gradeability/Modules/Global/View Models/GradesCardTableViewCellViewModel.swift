//
//  GradesCardTableViewCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class GradesCardTableViewCellViewModel: GradesCardTableViewCellRepresentable {
    
    var gradeCardViewModel: GradeCardViewModel
    var maxGradeCardViewModel: GradeCardViewModel
    
    init(gradeCardViewModel: GradeCardViewModel, maxGradeCardViewModel: GradeCardViewModel) {
        self.gradeCardViewModel = gradeCardViewModel
        self.maxGradeCardViewModel = maxGradeCardViewModel
    }
    
}
