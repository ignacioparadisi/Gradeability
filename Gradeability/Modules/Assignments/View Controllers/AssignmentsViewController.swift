//
//  AssignmentsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwipeCellKit

class AssignmentsViewController: GradablesViewController {
    
    // MARK: Properties
    /// View model for the view
    private let viewModel: AssignmentsViewModel
    /// View for showing in case there's no assignments
    private var emptyView: EmptyGradablesView?
    
    // MARK: Initializers
    init(viewModel: AssignmentsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GradesCardCollectionViewCell.self)
        collectionView.register(AssignmentCollectionViewCell.self)
    }
    
    override func createDataSource() -> UICollectionViewDiffableDataSource<Sections, AnyHashable> {
        return UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, gradable in
            guard let section = Sections(rawValue: indexPath.section) else { return nil }
            switch section {
            case .gradables:
                guard let gradable = gradable as? GradableCellViewModel else { return nil }
                let cell = collectionView.dequeueReusableCell(for: indexPath) as AssignmentCollectionViewCell
                let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
                cell.configure(with: gradable, position: self.viewModel.positionForCell(at: indexPath))
                #if !targetEnvironment(macCatalyst)
                cell.delegate = self
                #endif
                cell.addInteraction(contextMenuInteraction)
                return cell
            case .grade:
                let cell = collectionView.dequeueReusableCell(for: indexPath) as GradesCardCollectionViewCell
                guard let viewModel = self.viewModel.gradeCardViewModel else { return nil }
                cell.configure(with: viewModel)
                return cell
            }
        }
    }
    
    override func createSnapshot() -> NSDiffableDataSourceSnapshot<Sections, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        snapshot.appendSections(Sections.allCases)
        snapshot.appendItems([viewModel.gradeCardViewModel], toSection: .grade)
        snapshot.appendItems(viewModel.gradables, toSection: .gradables)
        return snapshot
    }
    
    /// Setup all View Model's closures to update the UI.
    override func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            if self?.viewModel.numberOfRows(in: 1) == 0 {
                self?.showEmptyView()
            }
            #if !targetEnvironment(macCatalyst)
            self?.title = self?.viewModel.title
            #endif
            self?.reloadData()
        }
    }
    
    /// Show view for creating an assignment in case there's no one created yet.
    private func showEmptyView() {
        emptyView = EmptyGradablesView(imageName: "doc.circle.fill",
                                       description: AssignmentString.emptyAssignments.localized,
                                       buttonTitle: AssignmentString.createAssignment.localized)
        emptyView?.delegate = self
        view.addSubview(emptyView!)
        emptyView?.anchor.edgesToSuperview().activate()
    }
    
    /// Handle navigation button for creating a new assignment
    /// - Parameter sender: Tap gesture
    override func didTapAddButton(_ sender: UIBarButtonItem?) {
        goToCreateAssignmentViewController()
    }
    
    @objc func goToCreateAssignmentViewController() {
        let createAssignmentViewController = CreateAssignmentViewController()
        createAssignmentViewController.isModalInPresentation = true
        let viewController = UINavigationController(rootViewController: createAssignmentViewController)
        present(viewController, animated: true)
    }
    
    override func didTapOptionsButton(_ sender: UIBarButtonItem?) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: "New", imageName: "plus", style: .default, handler: { [weak self] _ in
            self?.goToCreateAssignmentViewController()
        })
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
        touchBar.defaultItemIdentifiers = [.newAssignment]
        let button = NSButtonTouchBarItem(identifier: .newAssignment, title: "New Assignment", image: UIImage(systemName: "plus")!, target: self, action: nil)
        touchBar.templateItems = [button]
        return touchBar
    }
    #endif
    
}

// MARK: - EmptyGradablesViewDelegate
extension AssignmentsViewController: EmptyGradablesViewDelegate {
    
    /// Handle create button tap when there's no assignment created
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

// MARK: - UIContextMenuInteractionDelegate
extension AssignmentsViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInCollection = interaction.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: locationInCollection) else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            return self?.viewModel.createContextualMenuForRow(at: indexPath)
        }
    }

}

#if !targetEnvironment(macCatalyst)
extension AssignmentsViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
        }
        deleteAction.transitionDelegate = ScaleTransition.default
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        deleteAction.textColor = .red
        deleteAction.backgroundColor = .clear
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            // handle action by updating model with deletion
        }
        editAction.transitionDelegate = ScaleTransition.default
        // customize the action appearance
        editAction.image = UIImage(systemName: "pencil.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        editAction.textColor = .systemBlue
        editAction.backgroundColor = .clear

        return [deleteAction, editAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        options.backgroundColor = .clear
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.expansionStyle = .fill
        return options
    }
}
#endif
