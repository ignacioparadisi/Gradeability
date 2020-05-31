//
//  AssignmentsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class AssignmentsViewController: GradablesViewController {
    private let viewModel: AssignmentsViewModel
    private var emptyView: EmptyGradablesView?
    
    init(viewModel: AssignmentsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        emptyView = EmptyGradablesView(imageName: "doc.circle.fill",
                                       description: "It seems that you don't have any assignment in this subject.",
                                       buttonTitle: "Create Assignment")
        emptyView?.delegate = self
        view.addSubview(emptyView!)
        emptyView?.anchor.edgesToSuperview().activate()
    }
}

extension AssignmentsViewController: EmptyGradablesViewDelegate {
    func didTapButton() {
        viewModel.createAssignment()
        viewModel.fetch()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.emptyView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.emptyView?.removeFromSuperview()
            self?.emptyView = nil
        })
    }
}
