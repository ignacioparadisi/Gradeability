//
//  MainSplitViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    
    private let loadingView = UIView()
    private var emptyView: EmptyGradablesView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .allVisible
        // setupLoadingView()
        setupSplitViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // showWelcomeView()
    }

    // TODO: Probably delete this method
    private func setupLoadingView() {
        loadingView.backgroundColor = .systemGroupedBackground
        view.addSubview(loadingView)
        loadingView.anchor.edgesToSuperview().activate()
        
        let centerView = UIView()
        let activityIndicator = UIActivityIndicatorView()
        let loadingLabel = UILabel()
        loadingLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        loadingLabel.text = "LOADING"
        
        centerView.addSubview(activityIndicator)
        centerView.addSubview(loadingLabel)
        
        activityIndicator.anchor
            .topToSuperview()
            .centerXToSuperview()
            .activate()
        loadingLabel.anchor
            .top(to: activityIndicator.bottomAnchor, constant: 10)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        
        loadingView.addSubview(centerView)
        centerView.anchor.centerToSuperview().activate()
        
        activityIndicator.startAnimating()
    }
    
    /// Setup view controllers for the `SplitViewController`
    private func setupSplitViewControllers() {
        var term: Term?
        do {
            term = try CoreDataFactory.createTermManager.getCurrent()
        } catch {
            print(error.localizedDescription)
        }
        
        if let term = term {
            let assignmentsViewModel = AssignmentsViewModel()
            let subjectsViewModel = SubjectsViewModel(term: term)
            subjectsViewModel.delegate = assignmentsViewModel
            let subjectsViewController = SubjectsViewController(viewModel: subjectsViewModel)
            let assignmentsViewController = AssignmentsViewController(viewModel: assignmentsViewModel)
            let masterViewController = UINavigationController(rootViewController: subjectsViewController)
            
            let detailViewController = UINavigationController(rootViewController: assignmentsViewController)
            viewControllers = [masterViewController, detailViewController]
            // loadingView.removeFromSuperview()
        } else {
            showCreateTermView()
        }
    }
    
    private func showCreateTermView() {
        emptyView = EmptyGradablesView(imageName: "calendar.circle.fill",
                                       description: "To get started create a Term.",
                                       buttonTitle: "Create Term")
        emptyView?.delegate = self
        view.addSubview(emptyView!)
        emptyView?.anchor.edgesToSuperview().activate()
    }
    
    private func goToCreateTerm() {
        TermCoreDataManager.shared.create(name: "Semestre", maxGrade: 20, minGrade: 10)
        setupSplitViewControllers()
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.emptyView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.emptyView?.removeFromSuperview()
            self?.emptyView = nil
        })
    }
    
    private func showWelcomeView() {
        let viewController = WelcomeViewController()
        viewController.isModalInPresentation = true
        present(viewController, animated: true)
    }
    
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension MainSplitViewController: EmptyGradablesViewDelegate {
    func didTapButton() {
        goToCreateTerm()
    }
}
