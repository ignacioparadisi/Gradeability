//
//  GradesCardTableViewCellViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

struct GradesCardCollectionViewCellViewModel: GradesCardCollectionViewCellRepresentable, Hashable {
    
    /// View model for the `GradeCardView` that shows the current grade
    var gradeCardViewModel: GradeCardViewModel
    
    init(gradeCardViewModel: GradeCardViewModel) {
        self.gradeCardViewModel = gradeCardViewModel
    }
    
    static func == (lhs: GradesCardCollectionViewCellViewModel, rhs: GradesCardCollectionViewCellViewModel) -> Bool {
        return lhs.gradeCardViewModel == rhs.gradeCardViewModel
    }
    
}
