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
    let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    var loadingView: LoadingView?
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
        title = viewModel.title
        guard let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) else { return }
        guard let optionsImage = UIImage(systemName: "ellipsis.circle") else { return }
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didTapAddButton(_:))),
            UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(didTapOptionsButton(_:)))
        ], animated: false)
    }
    
    /// Setup all View Model's closures to update the UI
    func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.title = self?.viewModel.title
            self?.tableView.reloadData()
        }
    }
    
    func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView!)
        loadingView?.anchor.edgesToSuperview().activate()
    }
    
    func removeLoadingView() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.loadingView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.loadingView?.removeFromSuperview()
            self?.loadingView = nil
        })
    }
    
    @objc func didTapOptionsButton(_ sender: UIBarButtonItem?) {
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem?) {
        
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

