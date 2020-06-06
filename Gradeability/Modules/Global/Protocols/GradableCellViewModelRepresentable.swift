//
//  GradableCellViewModelRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol GradableCellViewModelRepresentable {
    // MARK: Properties
    /// Name to be displayed.
    var name: String { get }
    /// Detail to be displayed.
    var detail: String { get }
    /// Accessory type for the cell.
    var accessoryType: UITableViewCell.AccessoryType { get }
}
