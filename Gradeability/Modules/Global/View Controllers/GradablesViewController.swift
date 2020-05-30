//
//  ViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradablesViewController: UIViewController {
    // MARK: Private Properties
    /// `UITableView` to display the information.
    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    /// View Model that holds the data.
    private var viewModel: GradableViewModelRepresentable
    
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
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        tableView.register(GradableTableViewCell.self)
        
        viewModel.fetch()
    }
    
    /// Sets the Title and Bar Buttons to the Navigation Bar
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        guard let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) else { return }
        guard let optionsImage = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) else { return }
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: addImage, style: .plain, target: self, action: nil),
            UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(showOptionsAlert))
        ], animated: false)
    }
    
    /// Setup all View Model's closures to update the UI
    private func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func showOptionsAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let viewTermsAction = UIAlertAction(title: "View All Terms", style: .default) { [weak self] _ in
            let termsViewModel = TermsViewModel()
            let viewController = GradablesViewController(viewModel: termsViewModel)
            self?.present(UINavigationController(rootViewController: viewController), animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(viewTermsAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }


}

// MARK: - UITableViewDataSource
extension GradablesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
        cell.accessoryType = cellViewModel.accessoryType
        cell.textLabel?.text = cellViewModel.name
        cell.detailTextLabel?.text = cellViewModel.detail
        cell.addInteraction(contextMenuInteraction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle
    }
}

// MARK: - UITableViewDelegate
extension GradablesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let (nextViewModel, navigationStyle) = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = GradablesViewController(viewModel: nextViewModel)
        switch navigationStyle {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .detail:
            let navigationController = UINavigationController(rootViewController: viewController)
            showDetailViewController(navigationController, sender: self)
        case .present:
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        }
        
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

