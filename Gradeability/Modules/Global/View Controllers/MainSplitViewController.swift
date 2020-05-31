//
//  MainSplitViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    
    var loadingView: LoadingView?
    private var emptyView: EmptyGradablesView?
    private var subjectsViewModel: SubjectsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .allVisible
        setupSplitViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // showWelcomeView()
    }

    func showLoadingView() {
        loadingView = LoadingView()
        view.addSubview(loadingView!)
        loadingView?.anchor.edgesToSuperview().activate()
    }
    
    func removeLoadingView() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.loadingView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.loadingView?.removeFromSuperview()
            self?.loadingView = nil
        })
    }
    
    /// Setup view controllers for the `SplitViewController`
    private func setupSplitViewControllers() {
        var term: Term?
        term = CoreDataFactory.createTermManager.getCurrent()

        let assignmentsViewModel = AssignmentsViewModel()
        subjectsViewModel = SubjectsViewModel(term: term)
        subjectsViewModel?.delegate = assignmentsViewModel
        let subjectsViewController = SubjectsViewController(viewModel: subjectsViewModel!)
        let assignmentsViewController = AssignmentsViewController(viewModel: assignmentsViewModel)
        let masterViewController = UINavigationController(rootViewController: subjectsViewController)
        let detailViewController = UINavigationController(rootViewController: assignmentsViewController)
        viewControllers = [masterViewController, detailViewController]
        
        if term == nil {
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
        CoreDataFactory.createTermManager.create(name: "Semestre", maxGrade: 20, minGrade: 10)
        subjectsViewModel?.setTerm(CoreDataFactory.createTermManager.getCurrent())
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.emptyView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.emptyView?.removeFromSuperview()
            self?.emptyView = nil
            self?.subjectsViewModel = nil
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
