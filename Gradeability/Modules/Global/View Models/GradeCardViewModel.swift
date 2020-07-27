//
//  GradeCardViewModel.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradeCardViewModel {
    
    // MARK: Properties
    /// Gradable
    private let gradable: Gradable
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
    init(gradable: Gradable, message: String) {
        self.gradable = gradable
        self.message = message
    }
    
    static func == (lhs: GradeCardViewModel, rhs: GradeCardViewModel) -> Bool {
        lhs.gradable == rhs.gradable
    }
    
}

extension GradeCardViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(gradable)
    }
}
