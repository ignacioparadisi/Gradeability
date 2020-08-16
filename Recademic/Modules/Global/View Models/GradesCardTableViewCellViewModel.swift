//
//  GradesCardTableViewCellViewModel.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

class GradesCardCollectionViewCellViewModel: GradesCardCollectionViewCellRepresentable, Hashable {
    
    /// View model for the `GradeCardView` that shows the current grade
    var gradeCardViewModel: GradeCardViewModel
    var subjectInformationViewModel: SubjectInformationViewModel?
    
    init(gradeCardViewModel: GradeCardViewModel, subjectInformationViewModel: SubjectInformationViewModel? = nil) {
        self.gradeCardViewModel = gradeCardViewModel
        self.subjectInformationViewModel = subjectInformationViewModel
    }
    
    static func == (lhs: GradesCardCollectionViewCellViewModel, rhs: GradesCardCollectionViewCellViewModel) -> Bool {
        return lhs.gradeCardViewModel == rhs.gradeCardViewModel && lhs.subjectInformationViewModel == rhs.subjectInformationViewModel
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(gradeCardViewModel)
        hasher.combine(subjectInformationViewModel)
    }
    
}
