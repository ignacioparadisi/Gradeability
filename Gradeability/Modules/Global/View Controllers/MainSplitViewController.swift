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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .allVisible
        
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
        
        fetchDataForViewControllers()
    }
    
    private func fetchDataForViewControllers() {
        var term: Term?
        do {
            term = try CoreDataFactory.createTermManager.getCurrent()
        } catch {
            print(error.localizedDescription)
        }
        
        if let term = term {
            let subjectsViewModel = SubjectsViewModel(term: term)
            subjectsViewModel.fetch()
            subjectsViewModel.dataDidChange = { [weak self] in
                let masterViewController = UINavigationController(rootViewController: SubjectsViewController(viewModel: subjectsViewModel))
                if let assignmentsViewModel = subjectsViewModel.nextViewModelForRow(at: IndexPath(row: 0, section: 0)) {
                    let detailViewController = UINavigationController(rootViewController: AssignmentsViewController(viewModel: assignmentsViewModel as! AssignmentsViewModel))
                    self?.viewControllers = [masterViewController, detailViewController]
                    self?.loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
