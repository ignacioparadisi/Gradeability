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
        viewModel.fetch()
    }
    
    override func createDataSource() -> UICollectionViewDiffableDataSource<Sections, AnyHashable> {
        return UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, gradable in
//            guard let section = Sections(rawValue: indexPath.section) else { return nil }
//            switch section {
//            case .gradables:
                guard let gradable = gradable as? GradableCellViewModel else { return nil }
                let cell = collectionView.dequeueReusableCell(for: indexPath) as TermCollectionViewCell
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

// MARK: - UITableViewDataSource
extension TermsViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = viewModel.gradableViewModelForRow(at: indexPath)
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        let cell = tableView.dequeueReusableCell(for: indexPath) as TermTableViewCell
        cell.configure(with: cellViewModel)
        cell.addInteraction(contextMenuInteraction)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(for: section)
    }
    
}

// MARK: - UICollectionViewDelegate
extension TermsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
