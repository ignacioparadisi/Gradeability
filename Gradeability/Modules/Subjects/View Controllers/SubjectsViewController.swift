//
//  SubjectsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SubjectsViewController: GradablesViewController {
    
    // MARK: Properties
    /// View model for the view controller
    private let viewModel: SubjectsViewModel
    /// View for showing in case there's no assignments
    private var emptyView: EmptyGradablesView?
    
    // MARK: Initializers
    init(viewModel: SubjectsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(GradesCardTableViewCell.self)
        #if !targetEnvironment(macCatalyst)
        if viewModel.isMasterController {
            navigationItem.setLeftBarButton(
                UIBarButtonItem(title: "All Terms", style: .plain, target: self, action: #selector(showAllTerms)),
            animated: false)
        }
        #endif
    }

    /// Setup all View Model's closures to update the UI
    override func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            if self?.viewModel.numberOfRows(in: 1) == 0 {
                self?.showEmptyView()
            }
            self?.title = self?.viewModel.title
            self?.tableView.reloadData()
        }
        viewModel.didDeleteTerm = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        viewModel.loadingDidChange = { [weak self] isLoading in
        }
    }
    
    /// Show view for creating an assignment in case there's no one created yet.
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
    
    /// Handle navigation button for creating a new subject
    /// - Parameter sender: Tap gesture
    override func didTapAddButton(_ sender: UIBarButtonItem?) {
        let viewController = UINavigationController(rootViewController: CreateSubjectViewController())
        present(viewController, animated: true)
    }
    
    override func didTapOptionsButton(_ sender: UIBarButtonItem?) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: "New Subject", imageName: "plus", style: .default, handler: nil)
        let seeDetailAction = UIAlertAction(title: "See Details", imageName: "info.circle", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: ButtonStrings.cancel.localized, style: .cancel, handler: nil)
        
        alertSheet.addAction(createAction)
        alertSheet.addAction(seeDetailAction)
        
        if viewModel.canDeleteTerm {
            let deleteAction = UIAlertAction(title: ButtonStrings.delete.localized, imageName: "trash", style: .destructive) { [weak self] _ in
                self?.viewModel.deleteTerm()
            }
            alertSheet.addAction(deleteAction)
        }
        
        alertSheet.addAction(cancelAction)
        
        if let popoverController = alertSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(alertSheet, animated: true)
    }
    
    #if targetEnvironment(macCatalyst)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.defaultItemIdentifiers = [.newSubject]
        let button = NSButtonTouchBarItem(identifier: .newSubject, title: "New Subject", image: UIImage(systemName: "plus")!, target: self, action: nil)
        touchBar.templateItems = [button]
        return touchBar
    }
    #endif
    
}

// MARK: - UITableViewDataSource
extension SubjectsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .grade:
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradesCardTableViewCell
            guard let viewModel = self.viewModel.gradeCardViewModelForRow(at: indexPath) else { return UITableViewCell() }
            cell.configure(with: viewModel)
            return cell
        case .gradables:
            let cellViewModel = viewModel.gradableViewModelForRow(at: indexPath)
            let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
            let cell = tableView.dequeueReusableCell(for: indexPath) as GradableTableViewCell
            cell.configure(with: cellViewModel)
            cell.addInteraction(contextMenuInteraction)
            return cell
        }
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

// MARK: - EmptyGradablesViewDelegate
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
