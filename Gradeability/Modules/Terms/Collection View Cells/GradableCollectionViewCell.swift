//
//  GradableCollectionViewCell.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

protocol SwipableCell {
    func handleSwipe(_ gesture: UIPanGestureRecognizer)
    func resetState()
}

// TODO: Hacer que esto funcione para hacerlo reutilizable
//class SwipableCollectionViewCell: UICollectionViewCell, ReusableView, SwipableCell {
//    private var deleteButtonWidthAnchor: NSLayoutConstraint?
//    private var contentViewCenterXAnchor: Anchor?
//    private var contentViewTrailingButtonAnchor: Anchor?
//    private var deleteButton: UIButton = UIButton()
//    private var panGesture: UIPanGestureRecognizer?
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        setupDeleteButton()
//        contentView.anchor
//            .topToSuperview()
//            .width(to: widthAnchor)
//            .bottomToSuperview()
//            .activate()
//        contentViewCenterXAnchor = contentView.anchor.centerXToSuperview()
//        contentViewCenterXAnchor?.activate()
//    }
//
//    private func setupDeleteButton() {
//        deleteButton.backgroundColor = .systemRed
//        deleteButton.setTitle("Delete", for: .normal)
//        deleteButton.tintColor = .white
//        deleteButton.layer.cornerRadius = 15
//        insertSubview(deleteButton, at: 0)
//        deleteButton.anchor
//            .topToSuperview()
//            .trailingToSuperview()
//            .bottomToSuperview()
//            .activate()
//
//        deleteButtonWidthAnchor = deleteButton.widthAnchor.constraint(equalToConstant: 100)
//        deleteButtonWidthAnchor?.isActive = true
//        contentViewTrailingButtonAnchor = deleteButton.anchor.leading(to: contentView.trailingAnchor, constant: 10)
//        deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
////        if panGesture?.state == .changed {
////            let startPosition = self.convert(contentView.frame, to: nil).minX - 20
////            if abs(startPosition / 110) > 1 {
////                deleteButtonWidthAnchor?.constant = -startPosition - 10
////            }
////        }
//    }
//
//     func handleSwipe(_ gesture: UIPanGestureRecognizer) {
//        if panGesture == nil {
//            panGesture = gesture
//        }
//            switch gesture.state {
//            case .began:
//                break
//            case .changed:
//                let startPosition = self.convert(contentView.frame, to: nil).minX - 20
//                let translationX = gesture.translation(in: self).x
//                contentView.transform = CGAffineTransform(translationX: translationX, y: 0)
//                if abs(startPosition / 110) <= 1 {
//                    deleteButton.transform = CGAffineTransform(scaleX: abs(startPosition / 110), y: abs(startPosition / 110))
//                } else {
////                    deleteButtonWidthAnchor?.isActive = false
////                    contentViewTrailingButtonAnchor?.activate()
//    //                 deleteButtonWidthAnchor?.constant = -startPosition - 10
//                }
//
//            case .ended:
//                panGesture = nil
//                let startPosition = self.convert(contentView.frame, to: nil).minX - 20
//                print(abs(startPosition / 110))
//                var hideDeleteButton = true
//                // deleteButtonWidthAnchor?.isActive = true
//                if abs(startPosition / 110) > 0.5 {
//                    hideDeleteButton = false
//                    deleteButtonWidthAnchor?.constant = 100
//                    contentViewCenterXAnchor?.deactivate()
//                    contentViewTrailingButtonAnchor?.activate()
//                } else if abs(startPosition / 110) <= 1 {
//                    hideDeleteButton = true
//                    contentViewCenterXAnchor?.activate()
//                    contentViewTrailingButtonAnchor?.deactivate()
//                }
//                UIView.animate(withDuration: 0.2) {
//                    self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
//                    if hideDeleteButton {
//                        self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//                    } else {
//                       self.deleteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//                    }
//                    self.layoutIfNeeded()
//                }
//                break
//
//            default:
//                print(gesture.state)
//                break
//            }
//        }
//
//    func resetState() {
//        contentViewCenterXAnchor?.activate()
//        contentViewTrailingButtonAnchor?.deactivate()
//        UIView.animate(withDuration: 0.2) {
//            self.contentView.transform = CGAffineTransform(translationX: 0, y: 0)
//            self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//            self.layoutIfNeeded()
//        }
//    }
//
//}
//
//class GradableCollectionViewCell: SwipableCollectionViewCell {
//    private let primaryCellView: GradableCellPrimaryView = GradableCellPrimaryView()
//    private let secondaryCellView = GradableCellSecondaryView()
//    private var primaryViewBottomAnchor: Anchor?
//
//    override init(frame: CGRect) {
//        super.init(frame: .zero)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setupView() {
//        contentView.backgroundColor = UIColor(named: "cellSecondaryBackgroundColor")
//        contentView.layer.cornerRadius = 15
//        contentView.addSubview(primaryCellView)
//        primaryCellView.anchor
//            .topToSuperview()
//            .trailingToSuperview()
//            .leadingToSuperview()
//            .activate()
//        primaryViewBottomAnchor = primaryCellView.anchor.bottomToSuperview()
//        setupSecondaryView()
//    }
//
//    private func setupSecondaryView() {
//        contentView.addSubview(secondaryCellView)
//        secondaryCellView.anchor
//            .top(to: primaryCellView.bottomAnchor)
//            .trailingToSuperview()
//            .bottomToSuperview()
//            .leadingToSuperview()
//            .activate()
//    }
//
//    func configure(with viewModel: GradableCellViewModelRepresentable) {
//        primaryCellView.configure(with: viewModel.primaryViewModel)
//        if viewModel.shouldShowSecondaryView {
//            addShadow(height: 6)
//            primaryViewBottomAnchor?.deactivate()
//            setupSecondaryView()
//            secondaryCellView.configure(with: viewModel.secondaryViewTitle ?? "", progress: viewModel.secondaryViewProgress ?? 0.0, progressText: viewModel.secondaryViewProgressText ?? "")
//        } else {
//            removeShadow()
//            primaryViewBottomAnchor?.activate()
//            secondaryCellView.removeFromSuperview()
//        }
//    }
//}

class GradableCollectionViewCell: UICollectionViewCell, ReusableView, SwipableCell {
    private let primaryCellView: GradableCellPrimaryView = GradableCellPrimaryView()
    private let secondaryCellView = GradableCellSecondaryView()
    private var primaryViewBottomAnchor: Anchor?
    private var containerView: UIView = UIView()
    private var containerCenterXAnchor: Anchor?
    private var containerTrailingButtonAnchor: Anchor?
    private var deleteButtonWidthAnchor: NSLayoutConstraint?
    var deleteButton: UIButton = UIButton()
    private var currentLocation: CGPoint = CGPoint(x: 0, y: 0)

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
        contentView.backgroundColor = .clear
        contentView.layer.cornerRadius = 15
        contentView.addSubview(containerView)
        containerView.backgroundColor = UIColor(named: "cellSecondaryBackgroundColor")
        containerView.layer.cornerRadius = 15
        containerView.anchor
            .topToSuperview()
            .width(to: contentView.widthAnchor)
            .bottomToSuperview()
            .activate()
        containerCenterXAnchor = containerView.anchor.centerXToSuperview()
        containerCenterXAnchor?.activate()
        containerView.addSubview(primaryCellView)
        primaryCellView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        primaryViewBottomAnchor = primaryCellView.anchor.bottomToSuperview()
        setupSecondaryView()
    }
    
    private func setupDeleteButton() {
        deleteButton.backgroundColor = .systemRed
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = 15
        contentView.insertSubview(deleteButton, at: 0)
        deleteButton.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .activate()

        deleteButtonWidthAnchor = deleteButton.widthAnchor.constraint(equalToConstant: 100)
        deleteButtonWidthAnchor?.isActive = true
        containerTrailingButtonAnchor = deleteButton.anchor.leading(to: containerView.trailingAnchor, constant: 10)
        deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
    }

    private func setupSecondaryView() {
        containerView.addSubview(secondaryCellView)
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

    func handleSwipe(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            break
        case .changed:
            let startPosition = contentView.convert(containerView.frame, to: nil).minX - 20
            let velocity = gesture.velocity(in: self)
            if velocity.x > 0 && startPosition == 0 {
                return
            }
            let translationX = gesture.translation(in: self).x
            containerView.transform = CGAffineTransform(translationX: translationX, y: 0)
            if abs(startPosition / 110) <= 1 {
                deleteButton.transform = CGAffineTransform(scaleX: abs(startPosition / 110), y: abs(startPosition / 110))
            } else {
                deleteButtonWidthAnchor?.constant = -startPosition - 10
            }
        default:
            let startPosition = contentView.convert(containerView.frame, to: nil).minX - 20
            let velocity = gesture.velocity(in: self)
            var hideDeleteButton = true
            if abs(startPosition / 110) > 0.5 && velocity.x < 0 {
                hideDeleteButton = false
                deleteButtonWidthAnchor?.constant = 100
                containerCenterXAnchor?.deactivate()
                containerTrailingButtonAnchor?.activate()
            } else if abs(startPosition / 110) <= 1 {
                hideDeleteButton = true
                containerCenterXAnchor?.activate()
                containerTrailingButtonAnchor?.deactivate()
            }
            UIView.animate(withDuration: 0.2) {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
                if hideDeleteButton {
                    self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
                } else {
                   self.deleteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                }
                self.layoutIfNeeded()
            }
        }
    }

    func resetState() {
        containerCenterXAnchor?.activate()
        containerTrailingButtonAnchor?.deactivate()
        UIView.animate(withDuration: 0.2) {
            self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
            self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.layoutIfNeeded()
        }
    }
    
//    @objc func onPan(_ gesture: UIPanGestureRecognizer) {
//        switch gesture.state {
//        case .began:
//            break
//        case .changed:
//            let startPosition = contentView.convert(containerView.frame, to: nil).minX - 20
//            let translationX = gesture.translation(in: self).x
//            print(translationX)
//            containerView.transform = CGAffineTransform(translationX: translationX, y: 0)
//            if abs(startPosition / 110) <= 1 {
//                deleteButton.transform = CGAffineTransform(scaleX: abs(startPosition / 110), y: abs(startPosition / 110))
//            } else {
//                deleteButtonWidthAnchor?.isActive = false
//                containerTrailingButtonAnchor?.activate()
//                // deleteButtonWidthAnchor?.constant = -startPosition - 10
//            }
//        case .ended:
//            let startPosition = contentView.convert(containerView.frame, to: nil).minX - 20
//            var hideDeleteButton = true
//            deleteButtonWidthAnchor?.isActive = true
//            if abs(startPosition / 110) > 0.5 {
//                hideDeleteButton = false
//                deleteButtonWidthAnchor?.constant = 100
//                containerCenterXAnchor?.deactivate()
//                containerTrailingButtonAnchor?.activate()
//            } else if abs(startPosition / 110) <= 1 {
//                hideDeleteButton = true
//                containerCenterXAnchor?.activate()
//                containerTrailingButtonAnchor?.deactivate()
//            }
//            UIView.animate(withDuration: 0.2) {
//                self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
//                if hideDeleteButton {
//                    self.deleteButton.transform = CGAffineTransform(scaleX: 0, y: 0)
//                } else {
//                   self.deleteButton.transform = CGAffineTransform(scaleX: 1, y: 1)
//                }
//                self.layoutIfNeeded()
//            }
//            break
//
//        default:
//            break
//        }
//    }
    
}

//extension GradableCollectionViewCell: UIGestureRecognizerDelegate {
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        return abs((panGesture.velocity(in: panGesture.view)).x) > abs((panGesture.velocity(in: panGesture.view)).y)
//    }
//}

