//
//  GradeRingViewModel.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/9/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeRingViewModel {
    // MARK: Properties
    /// Gradable to show
    private var gradable: Gradable
    /// Color for the ring
    var color: UIColor {
        return UIColor.getColor(for: gradable)
    }
    ///
    var angleMultiplier: CGFloat {
        return CGFloat(gradable.grade / gradable.maxGrade)
    }
    /// Grade of the gradable
    var grade: String {
        return gradable.grade.format(decimals: 0)
    }
    
    // MARK: Initializer
    init(gradable: Gradable) {
        self.gradable = gradable
    }
}

