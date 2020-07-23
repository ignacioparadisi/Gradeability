//
//  UIColor+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/2/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIColor {
    /// Get color depending on grade
    /// Green if is a good grade
    /// Yellow if is a normal grade
    /// Red if is a bad grade
    ///
    /// - Parameter gradable: Gradable to evaluate
    /// - Returns: UIColor depending on grade
    static func getColor(for gradable: Gradable) -> UIColor {
        let roundedGrade = gradable.grade.rounded()
        let minGreenGrade = gradable.maxGrade - ((gradable.maxGrade - gradable.minGrade) / 3)
        if roundedGrade == gradable.maxGrade.rounded() {
            return .systemBlue
        } else if roundedGrade <= gradable.maxGrade, roundedGrade >= minGreenGrade {
            return .systemGreen
        } else if roundedGrade < minGreenGrade, roundedGrade >= gradable.minGrade {
            return .systemYellow
        } else {
            return .systemRed
        }
    }
    
    /// Creates a color lighter than self
    /// - Parameter percentage: Percentage of lightness
    /// - Returns: Color lighter than self
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    /// Creates a color darker than self
    /// - Parameter percentage: Percentage of darkness
    /// - Returns: Color darker than self
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
