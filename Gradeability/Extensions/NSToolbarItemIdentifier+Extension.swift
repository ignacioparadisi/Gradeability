//
//  NSToolbarItemIdentifier+Extension.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/6/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

#if targetEnvironment(macCatalyst)
/// Identifier for toolbar items
extension NSToolbarItem.Identifier {
    static let showAllTerms = NSToolbarItem.Identifier("ShowAllTerms")
    static let addNote = NSToolbarItem.Identifier("AddNote")
}
#endif
