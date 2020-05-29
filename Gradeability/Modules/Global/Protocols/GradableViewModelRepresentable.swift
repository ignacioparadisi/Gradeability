//
//  GradableViewModelRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol GradableViewModelRepresentable {
    var title: String { get }
    var numberOfRows: Int { get }
    var dataDidChange: (() -> Void)? { get set }
    func fetch()
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable?
}

protocol GradableCellViewModelRepresentable {
    var name: String { get }
    var detail: String { get }
}
