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
    private var emptyView: EmptyGradablesView?
    
    init(viewModel: SubjectsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel.isMasterController {
            navigationItem.setLeftBarButton(
                UIBarButtonItem(title: "All Terms", style: .plain, target: self, action: #selector(showAllTerms)),
            animated: false)
        }
    }

    /// Setup all View Model's closures to update the UI
    override func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            if self?.viewModel.numberOfRows == 0 {
                self?.showEmptyView()
            }
            self?.title = self?.viewModel.title
            self?.tableView.reloadData()
        }
    }
    
    private func showEmptyView() {
        emptyView = EmptyGradablesView(imageName: "book.circle.fill",
                                       description: "It seems that you don't have any subject in this term.",
                                       buttonTitle: "Create Subject")
        emptyView?.delegate = self
        view.addSubview(emptyView!)
        emptyView?.anchor.edgesToSuperview().activate()
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
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = AssignmentsViewController(viewModel: nextViewModel as! AssignmentsViewModel)
        if viewModel.isMasterController {
            showDetailViewController(UINavigationController(rootViewController: viewController), sender: nil)
        } else {
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SubjectsViewController: EmptyGradablesViewDelegate {
    func didTapButton() {
        viewModel.createSubject()
        viewModel.fetch()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.emptyView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.emptyView?.removeFromSuperview()
            self?.emptyView = nil
        })
    }
}
