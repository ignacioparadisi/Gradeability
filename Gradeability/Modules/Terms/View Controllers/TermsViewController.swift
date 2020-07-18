//
//  TermsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
import SwipeCellKit
import Combine

class TermsViewController: GradablesViewController {
    /// View Model for the View Controller
    private let viewModel: TermsViewModel
    private var subscriptions = Set<AnyCancellable>()

    init(viewModel: TermsViewModel) {
        self.viewModel = viewModel
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(GradableCollectionViewCell.self)
        viewModel.fetch()
    }
    
    override func createDataSource() -> UICollectionViewDiffableDataSource<Sections, AnyHashable> {
        return UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, gradable in
//            guard let section = Sections(rawValue: indexPath.section) else { return nil }
//            switch section {
//            case .gradables:
                guard let gradable = gradable as? GradableCellViewModel else { return nil }
                let cell = collectionView.dequeueReusableCell(for: indexPath) as GradableCollectionViewCell
                #if !targetEnvironment(macCatalyst)
                cell.delegate = self
                #endif
                let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
                cell.configure(with: gradable)
                cell.addInteraction(contextMenuInteraction)
                return cell
//            default:
//                return nil
//            }
        }
    }
    
    override func createSnapshot() -> NSDiffableDataSourceSnapshot<Sections, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, AnyHashable>()
        snapshot.appendSections([.gradables])
        snapshot.appendItems(viewModel.gradables, toSection: .gradables)
        return snapshot
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.reloadData()
        }
        viewModel.$gradables
            .map { $0.isEmpty }
            .sink { [weak self] isEmpty in
                if !isEmpty {
                    self?.reloadData()
                }
            }
            .store(in: &subscriptions)
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
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
        goToCreateTermViewController()
    }
    
    @objc func goToCreateTermViewController() {
        let viewController = UINavigationController(rootViewController: CreateTermViewController())
        present(viewController, animated: true)
    }
    
    override func didTapOptionsButton(_ sender: UIBarButtonItem?) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: "New", imageName: "plus", style: .default, handler: { [weak self] _ in
            self?.goToCreateTermViewController()
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
        touchBar.defaultItemIdentifiers = [.newTerm]
        let button = NSButtonTouchBarItem(identifier: .newTerm, title: "New Term", image: UIImage(systemName: "plus")!, target: self, action: nil)
        touchBar.templateItems = [button]
        return touchBar
    }
    #endif
}

// MARK: - UICollectionViewDelegate
extension TermsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let nextViewModel = viewModel.nextViewModelForRow(at: indexPath) else { return }
        let viewController = SubjectsViewController(viewModel: nextViewModel as! SubjectsViewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}


// MARK: - UIContextMenuInteractionDelegate
extension TermsViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let locationInCollection = interaction.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: locationInCollection) else { return nil }
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            return self?.viewModel.createContextualMenuForRow(at: indexPath)
        }
    }

}

#if !targetEnvironment(macCatalyst)
extension TermsViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [weak self] action, indexPath in
            self?.viewModel.deleteItem(at: indexPath)
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
        
        let setCurrentAction = SwipeAction(style: .default, title: "Set Current") { action, indexPath in
            // handle action by updating model with deletion
        }
        setCurrentAction.transitionDelegate = ScaleTransition.default
        // customize the action appearance
        setCurrentAction.image = UIImage(systemName: "pin.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        setCurrentAction.textColor = .systemGray
        setCurrentAction.backgroundColor = .clear

        return [deleteAction, setCurrentAction, editAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        options.backgroundColor = .clear
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        options.expansionStyle = .destructive(automaticallyDelete: false)
        return options
    }
}
#endif
