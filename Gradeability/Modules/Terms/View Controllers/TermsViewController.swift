//
//  TermsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class TermsViewController: GradablesViewController {
    /// View Model for the View Controller
    private let viewModel: TermsViewModel

    init(viewModel: TermsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if targetEnvironment(macCatalyst)
        let ellipsisImage = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissView)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(image: ellipsisImage, style: .plain, target: self, action: #selector(super.didTapOptionsButton(_:)))
        ], animated: false)
        #else
        navigationItem.setLeftBarButton(UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(dismissView)), animated: false)
        #endif
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    override func didTapAddButton(_ sender: UIBarButtonItem?) {
        let viewController = UINavigationController(rootViewController: CreateTermViewController())
        present(viewController, animated: true)
    }
    
    override func didTapOptionsButton(_ sender: UIBarButtonItem?) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: "New", imageName: "plus", style: .default, handler: nil)
        let seeDetailAction = UIAlertAction(title: "See Details", imageName: "info.circle", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: ButtonStrings.cancel.localized, style: .cancel, handler: nil)
        
        alertSheet.addAction(createAction)
        alertSheet.addAction(seeDetailAction)
        alertSheet.addAction(cancelAction)
        
        if let popoverController = alertSheet.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        present(alertSheet, animated: true)
    }
    
    #if targetEnvironment(macCatalyst)
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()
        touchBar.defaultItemIdentifiers = [.newTerm]
        let button = NSButtonTouchBarItem(identifier: .newTerm, title: "New Term", image: UIImage(systemName: "plus")!, target: self, action: nil)
        touchBar.templateItems = [button]
        return touchBar
    }
    #endif
}

// MARK: - UITableViewDelegate
extension TermsViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = SubjectsViewController(viewModel: nextViewModel as! SubjectsViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
