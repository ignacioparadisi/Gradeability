//
//  GradesCardTableViewCellRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol GradesCardTableViewCellRepresentable {
    var gradeCardViewModel: GradeCardViewModel { get }
    var maxGradeCardViewModel: GradeCardViewModel { get }
}
