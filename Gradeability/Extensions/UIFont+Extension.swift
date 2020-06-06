//
//  UILabel+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/5/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIFont {
    
    private func withTraits(_ traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    /// Sets font to bold
    var bold: UIFont {
        return withTraits(.traitBold)
    }
    
}
