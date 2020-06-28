//
//  GradeCardViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

struct GradeCardViewModel: Hashable {
    
    // MARK: Properties
    /// Gradable
    private let gradable: Gradable
    /// Type of grade. Grade or Max Grade
    let type: String
    /// Message to show
    let message: String
    /// Color of the card depending on grade
    var color: UIColor {
        return UIColor.getColor(for: gradable)
    }
    /// Grade
    var grade: String {
        return gradable.grade.format(decimals: 0)
    }
    
    // MARK: Initializer
    init(gradable: Gradable, type: String, message: String) {
        self.gradable = gradable
        self.type = type
        self.message = message
    }
    
    static func == (lhs: GradeCardViewModel, rhs: GradeCardViewModel) -> Bool {
        lhs.gradable == rhs.gradable
    }
    
}
