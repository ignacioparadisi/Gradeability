//
//  MainSplitViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainSplitViewController: UISplitViewController {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        var term: Term?
        do {
            term = try CoreDataManager.shared.fetchCurrentTerm()
        } catch {
            print(error.localizedDescription)
        }
        
        if let term = term {
            let subjectsViewModel = SubjectsViewModel(term: term)
            subjectsViewModel.fetch()
            let masterViewController = UINavigationController(rootViewController: GradablesViewController(viewModel: subjectsViewModel))
            if let (assignmentsViewModel, _) = subjectsViewModel.nextViewModelForRow(at: IndexPath(row: 0, section: 0)) {
                let detailViewController = UINavigationController(rootViewController: GradablesViewController(viewModel: assignmentsViewModel))
                viewControllers = [masterViewController, detailViewController]
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        primaryBackgroundStyle = .sidebar
        preferredDisplayMode = .allVisible
    }
    
}

extension MainSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
