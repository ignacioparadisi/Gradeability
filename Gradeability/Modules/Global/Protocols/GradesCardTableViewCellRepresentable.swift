//
//  GradesCardTableViewCellRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol GradesCardTableViewCellRepresentable {
    /// View model for the `GradeCardView` that shows the current grade
    var gradeCardViewModel: GradeCardViewModel { get }
    /// View model for the `GradeCardView` that shows the maximum grade that can be scored
    var maxGradeCardViewModel: GradeCardViewModel { get }
}
