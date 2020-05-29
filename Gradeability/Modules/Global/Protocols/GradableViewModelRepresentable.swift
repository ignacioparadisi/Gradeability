//
//  GradableViewModelRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

protocol GradableViewModelRepresentable {
    // MARK: Properties
    /// Title for the `UIViewController`.
    var title: String { get }
    /// Number of rows for the `UITableView`.
    var numberOfRows: Int { get }
    /// Closure called when the data changes so the UI can be updated.
    var dataDidChange: (() -> Void)? { get set }
    
    // MARK: Functions
    /// Fetches the data.
    func fetch()
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func viewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable?
}