//
//  TermsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermsViewController: GradablesViewController {
    /// View Model for the View Controller
    private let viewModel: TermsViewModel

    init(viewModel: TermsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView)), animated: false)
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    override func didTapAddButton(_ sender: UIBarButtonItem?) {
        let viewController = UINavigationController(rootViewController: CreateTermViewController())
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension TermsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = SubjectsViewController(viewModel: nextViewModel as! SubjectsViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
