//
//  String+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension String {
    /// Localize a string
    /// - Parameters:
    ///   - bundle: Bundle were the localizable file is located
    ///   - tableName: Name of the localizable file
    /// - Returns: A localized string
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, bundle: bundle, value: "**\(self)**", comment: "")
    }
}
