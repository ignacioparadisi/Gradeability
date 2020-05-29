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
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        guard let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) else { return }
        guard let optionsImage = UIImage(systemName: "ellipsis.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold)) else { return }
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: addImage, style: .plain, target: self, action: nil),
            UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: nil)
        ], animated: false)
    }
    
    /// Setup all View Model's closures to update the UI
    private func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }


}

// MARK: - UITableViewDataSource
extension GradablesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.viewModelForRow(at: indexPath)
        let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellViewModel.name
        cell.detailTextLabel?.text = cellViewModel.detail
        return cell
    }
}

// MARK: - UITableViewDelegate
extension GradablesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = GradablesViewController(viewModel: nextViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

