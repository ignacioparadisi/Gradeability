//
//  GradableCellPrimaryViewRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol GradableCellPrimaryViewRepresentable {
    /// Name of the gradable.
    var name: String { get }
    /// Detail for the gradable. It could be the date or teacher's name.
    var detail: String? { get }
    /// If exists, a blue text will appear on top of the name.
    var accentText: String? { get }
    /// Image icon for the detail.
    var systemImage: String? { get }
    /// View model for the ring view.
    var gradeRingViewModel: GradeRingViewModel { get }
}
