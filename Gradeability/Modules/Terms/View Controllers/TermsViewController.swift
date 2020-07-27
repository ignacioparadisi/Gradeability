//
//  TermsViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit
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
        collectionView.register(GradesCardCollectionViewCell.self)
        collectionView.register(GradableCollectionViewCell.self)
        viewModel.fetch()
    }

    override func createDataSource() -> UICollectionViewDiffableDataSource<Sections, AnyHashable> {
        return UICollectionViewDiffableDataSource<Sections, AnyHashable>(collectionView: collectionView) { collectionView, indexPath, gradable in
            guard let section = Sections(rawValue: indexPath.section) else { return nil }
            switch section {
            case .gradables:
                guard let gradable = gradable as? GradableCellViewModel else { return nil }
                let cell = collectionView.dequeueReusableCell(for: indexPath) as GradableCollectionViewCell
                let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
                cell.configure(with: gradable)
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
        if let cardViewModel = viewModel.gradeCardViewModel {
           snapshot.appendItems([cardViewModel], toSection: .grade)
       }
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
            guard let self = self else { return }
            self.reloadData()
        }
        viewModel.showDeleteAlert = { [weak self] index in
            guard let self = self else { return }
            let term = self.viewModel.gradables[index]
            let alertController = UIAlertController(title: String(format: TermStrings.deleteTitle.localized, term.name), message: TermStrings.deleteMessage.localized, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: ButtonStrings.cancel.localized, style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: ButtonStrings.delete.localized, style: .destructive) { [weak self] _ in
                self?.viewModel.deleteItem(at: index)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            self.present(alertController, animated: true)
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
        navigationItem.setLeftBarButton(UIBarButtonItem(title: ButtonStrings.close.localized, style: .plain, target: self, action: #selector(dismissView)), animated: false)
        #endif
    }
    
    @objc func dismissView() {
        dismiss(animated: true)
    }
    
    override func didTapAddButton(_ sender: UIBarButtonItem) {
        goToCreateTermViewController()
    }
    
    @objc func goToCreateTermViewController() {
        let viewController = UINavigationController(rootViewController: CreateTermViewController())
        present(viewController, animated: true)
    }
    
    override func didTapOptionsButton(_ sender: UIBarButtonItem?) {
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let createAction = UIAlertAction(title: TermStrings.newTerm.localized, imageName: "plus", style: .default, handler: { [weak self] _ in
            self?.goToCreateTermViewController()
        })
        let seeDetailAction = UIAlertAction(title: GlobalStrings.details.localized, imageName: "info.circle", style: .default, handler: nil)
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
        let button = NSButtonTouchBarItem(identifier: .newTerm, title: TermStrings.newTerm.localized, image: UIImage(systemName: "plus")!, target: self, action: nil)
        touchBar.templateItems = [button]
        return touchBar
    }
    #endif
}

// MARK: - UICollectionViewDelegate
extension TermsViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let section = Sections(rawValue: indexPath.section), section == .gradables else { return }
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
