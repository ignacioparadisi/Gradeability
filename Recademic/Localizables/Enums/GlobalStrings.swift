//
//  GlobalStrings.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

enum GlobalStrings: String, Localizable {
    var tableName: String {
        return "Global"
    }
    
    case name
    case grade
    case maxGrade
    case minGrade
    case welcomeTitle
    case welcomeMessage
    case loading
    case details
}
