//
//  GradeCardViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeCardViewModel {
    private let gradable: Gradable
    let type: String
    let message: String
    init(gradable: Gradable, type: String, message: String) {
        self.gradable = gradable
        self.type = type
        self.message = message
    }
    var color: UIColor {
        return UIColor.getColor(for: gradable)
    }
    var grade: String {
        return gradable.grade.format(decimals: 0)
    }
}
