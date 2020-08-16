//
//  ReusableView.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

/// Adds a reuse identifier to the View
protocol ReusableView: class {
    /// Identifier for reusable `UITableViewCells`.
    static var reusableIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    /// Identifier for reusable `UITableViewCells`.
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}
