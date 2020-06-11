//
//  UIButton+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIButton {
    
    func macStyled() -> UIButton {
        #if targetEnvironment(macCatalyst)
        self.backgroundColor = .tertiarySystemBackground
        #endif
        return self
    }
}
