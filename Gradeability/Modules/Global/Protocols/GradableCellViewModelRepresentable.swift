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
    var accentText: String? { get }
    /// Accessory type for the cell.
    var shouldShowSecondaryView: Bool { get }
    var gradeRingViewModel: GradeRingViewModel { get }
    var primaryViewModel: GradableCellPrimaryViewRepresentable { get }
    var secondaryViewTitle: String? { get }
    var secondaryViewProgress: Float? { get }
    var secondaryViewProgressText: String? { get }
}

