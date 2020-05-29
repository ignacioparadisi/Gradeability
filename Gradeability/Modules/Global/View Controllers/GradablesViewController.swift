//
//  ViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradablesViewController: UIViewController {

    private let tableView: UITableView = UITableView(frame: .zero, style: .insetGrouped)
    private var viewModel: GradableViewModelRepresentable
    
    init(viewModel: GradableViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        
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
    
    private func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.tableView.reloadData()
        }
    }


}

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

extension GradablesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = GradablesViewController(viewModel: nextViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

