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
    private let createTermView = UIView()

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
        // setupLoadingView()
        fetchDataForViewControllers()
    }
    
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
    
    private func fetchDataForViewControllers() {
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
            setupCreateTermView()
        }
    }
    
    private func setupCreateTermView() {
        let imageView = UIImageView()
        let label = UILabel()
        let button = UIButton()
        
        imageView.image = UIImage(systemName: "calendar.circle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray2
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        label.text = "To get started create a Term."
        label.numberOfLines = 2
        
        button.setTitle("Create Term", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        view.addSubview(createTermView)
        createTermView.addSubview(imageView)
        createTermView.addSubview(label)
        createTermView.addSubview(button)
        
        createTermView.anchor
            .top(greaterOrEqual: view.safeAreaLayoutGuide.topAnchor, constant: 50)
            .trailing(to: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
            .bottom(lessOrEqual: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            .leading(to: view.safeAreaLayoutGuide.leadingAnchor, constant: 30)
            .centerToSuperview()
            .activate()
        
        imageView.anchor
            .topToSuperview()
            .centerXToSuperview()
            .height(constant: min(view.frame.height, view.frame.width) * 0.6)
            .width(to: imageView.heightAnchor)
            .activate()
        
        label.anchor
            .top(to: imageView.bottomAnchor, constant: 40)
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        button.anchor
            .top(to: label.bottomAnchor, constant: 30)
            .trailing(lessOrEqual: createTermView.trailingAnchor)
            .leading(lessOrEqual: createTermView.leadingAnchor)
            .bottomToSuperview()
            .centerXToSuperview()
            .height(constant: 44)
            .width(lessThanOrEqualToConstant: 400)
            .activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // showWelcomeView()
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
