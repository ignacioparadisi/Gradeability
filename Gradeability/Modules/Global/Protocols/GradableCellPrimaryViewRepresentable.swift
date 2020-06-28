//
//  GradableCellPrimaryViewRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol GradableCellPrimaryViewRepresentable {
    var name: String { get }
    var detail: String? { get }
    var accentText: String? { get }
    var systemImage: String? { get }
    var gradeRingViewModel: GradeRingViewModel { get }
}
