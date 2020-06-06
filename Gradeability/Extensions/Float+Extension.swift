//
//  Float+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/3/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension Float {
    
    /// Formats the number to have a specific amount of decimals
    /// - Parameter decimals: Decimal that the number should have
    /// - Returns: String 
    func format(decimals: Int) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}
