//
//  NSTouchBarIdentifier+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)
/// Identifier for touch bar items.
extension NSTouchBarItem.Identifier {
    static let newAssignment = NSTouchBarItem.Identifier("newAssignment")
    static let newSubject = NSTouchBarItem.Identifier("newSubject")
    static let newTerm = NSTouchBarItem.Identifier("newTerm")
}
#endif
