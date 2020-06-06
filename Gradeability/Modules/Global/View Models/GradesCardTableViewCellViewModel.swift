//
//  GradesCardTableViewCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class GradesCardTableViewCellViewModel: GradesCardTableViewCellRepresentable {
    
    /// View model for the `GradeCardView` that shows the current grade
    var gradeCardViewModel: GradeCardViewModel
    /// View model for the `GradeCardView` that shows the maximum grade that can be scored
    var maxGradeCardViewModel: GradeCardViewModel
    
    init(gradeCardViewModel: GradeCardViewModel, maxGradeCardViewModel: GradeCardViewModel) {
        self.gradeCardViewModel = gradeCardViewModel
        self.maxGradeCardViewModel = maxGradeCardViewModel
    }
    
}
