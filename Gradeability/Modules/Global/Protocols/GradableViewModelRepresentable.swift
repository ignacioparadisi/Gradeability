//
//  GradableViewModelRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

enum NavigationStyle {
    case present
    case push
    case detail
}

protocol GradableViewModelRepresentable {
    // MARK: Properties
    /// Title for the `UIViewController`.
    var title: String { get }
    /// Number of sections for the `UITableView`.
    var numberOfSections: Int { get }
    /// Closure called when the data changes so the UI can be updated.
    var dataDidChange: (() -> Void)? { get set }
    
    // MARK: Functions
    /// Fetches the data.
    func fetch()
    /// Number of rows in a specific table view section
    func numberOfRows(in section: Int) -> Int
    func title(for section: Int) -> String?
    /// Gets the View Model for the `UITableViewCell` at the specified `IndexPath`.
    /// - Parameter indexPath: IndexPath where the View Model belongs.
    /// - Returns: The View Model for the specified `IndexPath`.
    func gradableViewModelForRow(at indexPath: IndexPath) -> GradableCellViewModelRepresentable
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable?
    /// Crete a contextual menu for a cell at a specific index path.
    /// - Parameter indexPath: Index path of the cell.
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu?
    /// Delete item at a specific index path.
    /// - Parameter indexPath: Index path of the cell.
    func deleteItem(at indexPath: IndexPath)
}
