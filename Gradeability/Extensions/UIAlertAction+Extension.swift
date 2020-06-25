//
//  UIAlertAction+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    convenience init(title: String?, imageName: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?) {
        self.init(title: title, style: style, handler: handler)
        if let imageName = imageName, let image = UIImage(systemName: imageName, withConfiguration:  UIImage.SymbolConfiguration(scale: .large)) {
            setValue(image, forKey: "image")
        }
    }
}
