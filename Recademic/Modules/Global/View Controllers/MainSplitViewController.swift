//
//  MainSplitViewController.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {
    
    // MARK: Properties
    /// View to be shown if there's no terms created.
    private var emptyView: EmptyGradablesView?
    /// View Model for  `SubjectsViewController`.
    private var subjectsViewModel: SubjectsViewModel?
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .allVisible
        maximumPrimaryColumnWidth = 350
        minimumPrimaryColumnWidth = 350
        setupSplitViewControllers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // showWelcomeView()
    }
    
    /// Setup view controllers for the `SplitViewController`
    private func setupSplitViewControllers() {
        var term: Term?
        term = TermCoreDataManager.shared.getCurrent()

        subjectsViewModel = SubjectsViewModel(term: term)
        let subjectsViewController = SubjectsViewController(viewModel: subjectsViewModel!)
        let masterViewController = UINavigationController(rootViewController: subjectsViewController)
        let detailViewController = UINavigationController(rootViewController: NoSubjectSelectedViewController())
        viewControllers = [masterViewController, detailViewController]
        
        if term == nil {
            showCreateTermView()
        }
    }
    
    /// Show a view for creating a terms if there's no terms created
    private func showCreateTermView() {
        emptyView = EmptyGradablesView(imageName: "calendar.circle.fill",
                                       description: "To get started create a Term.",
                                       buttonTitle: "Create Term")
        emptyView?.delegate = self
        view.addSubview(emptyView!)
        emptyView?.anchor.edgesToSuperview().activate()
    }
    
    /// Go to `CreateTermViewController`
    private func goToCreateTerm() {
        TermCoreDataManager.shared.create(name: "Semestre", maxGrade: 20, minGrade: 10)
        subjectsViewModel?.setTerm(TermCoreDataManager.shared.getCurrent())
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.emptyView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.emptyView?.removeFromSuperview()
            self?.emptyView = nil
            self?.subjectsViewModel = nil
        })
    }
    
    /// Show `WelcomeViewController` if it's the first time the user enters the app.
    private func showWelcomeView() {
        let viewController = WelcomeViewController()
        viewController.isModalInPresentation = true
        #if targetEnvironment(macCatalyst)
        viewController.modalPresentationStyle = .overFullScreen
        #endif
        present(viewController, animated: true)
    }
    
}

// MARK: - UISplitViewControllerDelegate
extension MainSplitViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
}

// MARK: - EmptyGradablesViewDelegate
extension MainSplitViewController: EmptyGradablesViewDelegate {
    
    func didTapButton() {
        goToCreateTerm()
    }
    
}
