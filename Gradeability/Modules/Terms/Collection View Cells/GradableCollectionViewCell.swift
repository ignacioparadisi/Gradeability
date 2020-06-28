//
//  GradableCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class GradableCollectionViewCell: UICollectionViewCell, ReusableView {
    private let primaryCellView: GradableCellPrimaryView = GradableCellPrimaryView()
    private let secondaryCellView = GradableCellSecondaryView()
    private var primaryViewBottomAnchor: Anchor?
    private var contentViewTrailingSuperviewAnchor: NSLayoutConstraint?
    private var contentViewTrailingButtonAnchor: NSLayoutConstraint?
    var deleteButton: UIButton = UIButton()
    private var isPanning: Bool = false
    private var currentLocation: CGPoint = CGPoint(x: 0, y: 0)
    
    var panGesture: UIPanGestureRecognizer!
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        setupDeleteButton()
        contentView.backgroundColor = UIColor(named: "cellSecondaryBackgroundColor")
        contentView.layer.cornerRadius = 15
        contentView.addSubview(primaryCellView)
        primaryCellView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        primaryViewBottomAnchor = primaryCellView.anchor.bottomToSuperview()
        setupSecondaryView()
        addGesture()
    }
    
    func addGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
    }
    
    private func setupDeleteButton() {
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 15
        insertSubview(deleteButton, at: 0)
        deleteButton.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .width(constant: 100)
            .activate()
        deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    private func setupSecondaryView() {
        contentView.addSubview(secondaryCellView)
        secondaryCellView.anchor
            .top(to: primaryCellView.bottomAnchor)
            .trailingToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
    }
    
    func configure(with viewModel: GradableCellViewModelRepresentable) {
        primaryCellView.configure(with: viewModel.primaryViewModel)
        if viewModel.shouldShowSecondaryView {
            addShadow(height: 6)
            primaryViewBottomAnchor?.deactivate()
            setupSecondaryView()
            secondaryCellView.configure(with: viewModel.secondaryViewTitle ?? "", progress: viewModel.secondaryViewProgress ?? 0.0, progressText: viewModel.secondaryViewProgressText ?? "")
        } else {
            removeShadow()
            primaryViewBottomAnchor?.activate()
            secondaryCellView.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (panGesture.state == .changed) {
            let locationX: CGFloat = min(panGesture.translation(in: self).x, currentLocation.x)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: locationX, y: 0, width: width, height: height)
            if abs(locationX / 100) <= 1 {
                deleteButton.transform = CGAffineTransform(scaleX: abs(locationX / 100), y: abs(locationX / 100))
            } else if abs(locationX / 110) > 1 {
                deleteButton.frame = CGRect(x: locationX + width + 10, y: 0, width: abs(locationX) - 10, height: height)
            }
        }
    }
    
    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            if gesture.velocity(in: self).x < 0 || currentLocation.x != 0{
                isPanning = true
            }
            if !isPanning { return }
            setNeedsLayout()
        case .ended:
            print("Ended")
            if abs(panGesture.translation(in: self).x) > 110 {
                currentLocation = CGPoint(x: -110, y: 0)
                let width = self.contentView.frame.width
                let height = self.contentView.frame.height
                self.contentView.frame = CGRect(x: -110, y: 0, width: width, height: height)
                self.deleteButton.frame = CGRect(x: width - 100, y: 0, width: 100, height: height)
            } else {
                currentLocation = CGPoint(x: 0, y: 0)
                UIView.animate(withDuration: 0.2, animations: {
                    self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
            
        default:
            isPanning = false
            UIView.animate(withDuration: 0.2, animations: {
                self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                self.setNeedsLayout()
                self.layoutIfNeeded()
            })
        }
    }
    
}

extension GradableCollectionViewCell: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
    }
}

