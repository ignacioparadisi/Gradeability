//
//  UIView+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIView {

    /// Add a shadow to a view
    /// - Parameter height: Height offset for the shadow.
    func addShadow(height: CGFloat = 2) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: height)
        layer.shadowRadius = 6
        layer.shadowOpacity = 0.2
        clipsToBounds = false
    }
    
    /// Removes the shadow from a view.
    func removeShadow() {
        layer.shadowOpacity = 0.0
    }
}
