//
//  GradableViewModelRepresentable.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/28/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol GradableViewModelRepresentable {
    // MARK: Properties
    /// Title for the `UIViewController`.
    var title: String { get }
    /// Closure called when the data changes so the UI can be updated.
    var dataDidChange: (() -> Void)? { get set }
    /// Closure to handle when the user selects the delete option from the contextual menu.
    var showDeleteAlert: ((Int) -> Void)? { get set }
    // MARK: Functions
    /// Fetches the data.
    func fetch()
    func title(for section: Int) -> String?
    /// Gets the View Model for the `UIViewController` to be displayed next when the user selects a `UITableViewCell`.
    /// - Parameter indexPath: IndexPath for the cell selected.
    func nextViewModelForRow(at indexPath: IndexPath) -> GradableViewModelRepresentable?
    /// Crete a contextual menu for a cell at a specific index path.
    /// - Parameter indexPath: Index path of the cell.
    func createContextualMenuForRow(at indexPath: IndexPath) -> UIMenu?
    /// Delete item at a specific index path.
    /// - Parameter indexPath: Index path of the cell.
    func deleteItem(at index: Int)
}
