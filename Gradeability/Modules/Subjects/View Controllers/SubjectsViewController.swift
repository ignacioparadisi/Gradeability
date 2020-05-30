//
//  SubjectsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectsViewController: GradablesViewController {
    private let viewModel: SubjectsViewModel
    
    init(viewModel: SubjectsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.isMasterController {
            navigationItem.setLeftBarButton(
                UIBarButtonItem(title: "All Terms", style: .plain, target: self, action: #selector(showAllTerms)),
            animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Present `GradablesViewController` for showing all Terms
    @objc private func showAllTerms() {
        let termsViewModel = viewModel.termsViewModel
        let viewController = TermsViewController(viewModel: termsViewModel)
        present(UINavigationController(rootViewController: viewController), animated: true)
    }
}

// MARK: - UITableViewDelegate
extension SubjectsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let (nextViewModel, _) = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = AssignmentsViewController(viewModel: nextViewModel as! AssignmentsViewModel)
        if viewModel.isMasterController {
            showDetailViewController(UINavigationController(rootViewController: viewController), sender: nil)
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
