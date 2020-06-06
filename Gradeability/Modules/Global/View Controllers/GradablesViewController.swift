//
//  ViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradablesViewController: UIViewController {
    // MARK: Properties
    /// `UITableView` to display the information.
    let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    /// View Model that holds the data.
    private var viewModel: GradableViewModelRepresentable
    /// Sections displayed in the table view
    enum Sections: Int, CaseIterable {
        case grade
        case gradables
    }
    
    // MARK: Initializers
    init(viewModel: GradableViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    /// Add the `tableView` to the `view` and set's it up.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
        setupTableView()
        viewModel.fetch()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.cellLayoutMarginsFollowReadableWidth = true
        view.addSubview(tableView)
        tableView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        tableView.register(GradableTableViewCell.self)
    }
    
    /// Sets the Title and Bar Buttons to the Navigation Bar
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        var optionsImage = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        var barButtons: [UIBarButtonItem] = []
        #if !targetEnvironment(macCatalyst)
        title = viewModel.title
        optionsImage = UIImage(systemName: "ellipsis.circle")
        barButtons.append(UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didTapAddButton(_:))))
        #endif
        barButtons.append(UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(didTapOptionsButton(_:))))
        
        navigationItem.setRightBarButtonItems(barButtons, animated: false)
    }
    
    /// Setup all View Model's closures to update the UI
    func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.title = self?.viewModel.title
            self?.tableView.reloadData()
        }
    }
    
    @objc func didTapOptionsButton(_ sender: UIBarButtonItem?) {
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem?) {
    }


}

// MARK: - UITableViewDataSource
extension GradablesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.gradableViewModelForRow(at: indexPath)
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
        cell.accessoryType = cellViewModel.accessoryType
        cell.textLabel?.text = cellViewModel.name
        cell.detailTextLabel?.text = cellViewModel.detail
        cell.addInteraction(contextMenuInteraction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
}

// MARK: - UITableViewDelegate
extension GradablesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

// MARK: = UIContextMenuInteractionDelegate
extension GradablesViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInTableView = interaction.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: locationInTableView) else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            return self?.viewModel.createContextualMenuForRow(at: indexPath)
        }
    }

}

