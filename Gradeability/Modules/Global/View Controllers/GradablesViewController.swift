//
//  ViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradablesViewController: UIViewController {
    // MARK: Properties
    /// View Model that holds the data.
    private var viewModel: GradableViewModelRepresentable
    var collectionView: UICollectionView!
    private var panGesture: UIPanGestureRecognizer!
    private var currentSwipeCell: GradableCollectionViewCell?
    private var currentGesture: UIGestureRecognizer?
    var dataSource: UICollectionViewDiffableDataSource<Sections, AnyHashable>!
    /// Sections displayed in the table view
    enum Sections: Int, CaseIterable {
        case grade
        case gradables
    }
    
    // MARK: Initializers
    init(viewModel: GradableViewModelRepresentable) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    /// Add the `tableView` to the `view` and set's it up.
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        setupNavigationBar()
        setupViewModel()
        setupCollectionView()
        viewModel.fetch()
    }
    
    private func setupCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource = createDataSource()
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGroupedBackground
        view.addSubview(collectionView)
        collectionView.anchor.edgesToSuperview().activate()
        addGesture()
    }
    
    func addGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        collectionView.addGestureRecognizer(panGesture)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 20)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createDataSource() -> UICollectionViewDiffableDataSource<Sections, AnyHashable> {
        fatalError("This method has to be overridden" )
    }
    
    func createSnapshot() -> NSDiffableDataSourceSnapshot<Sections, AnyHashable> {
        fatalError("This method has to be overridden")
    }
    
    
    @objc func refresh() {
        viewModel.fetch()
    }
    
    /// Sets the Title and Bar Buttons to the Navigation Bar
    func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        var optionsImage = UIImage(systemName: "ellipsis.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        #if targetEnvironment(macCatalyst)
        optionsImage = optionsImage?.withTintColor(.systemGray, renderingMode: .alwaysOriginal)
        #endif
        let addImage = UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
        var barButtons: [UIBarButtonItem] = []
        #if !targetEnvironment(macCatalyst)
        title = viewModel.title
        optionsImage = UIImage(systemName: "ellipsis.circle")
        barButtons.append(UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(didTapAddButton(_:))))
        #endif
        barButtons.append(UIBarButtonItem(image: optionsImage, style: .plain, target: self, action: #selector(didTapOptionsButton(_:))))
        
        navigationItem.setRightBarButtonItems(barButtons, animated: false)
    }
    
    /// Setup all View Model's closures to update the UI
    func setupViewModel() {
        viewModel.dataDidChange = { [weak self] in
            self?.title = self?.viewModel.title
            self?.reloadData()
        }
    }
    
    func reloadData() {
        let snapshot = createSnapshot()
        dataSource.apply(snapshot)
    }
    
    @objc func didTapOptionsButton(_ sender: UIBarButtonItem?) {
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem?) {
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: location),
            let cell = collectionView.cellForItem(at: indexPath) as? GradableCollectionViewCell else { return }
        if currentSwipeCell != cell {
            currentSwipeCell?.resetState()
            currentSwipeCell = cell
        }
        cell.handleSwipe(gesture)
        
    }
}

// MARK: - UITableViewDelegate
extension GradablesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let currentSwipeCell = currentSwipeCell {
            currentSwipeCell.resetState()
            self.currentSwipeCell = nil
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return true
    }
    
}

extension GradablesViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.state == .changed {
            return false
        }
        return false
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }

}

