//
//  WelcomeViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 5/30/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    /// Scroll View where that holds the `contentView`
    private let scrollView: UIScrollView = UIScrollView()
    /// View that holds all the information displayed in the `scrollView`
    private let contentView: UIView = UIView()
    /// Bottom background view where the create button is placed
    private let buttonBackgroundView = UIView()
    /// Blur view placed behind the create button. This view is clear when the content of the `contentView` is smaller than the scroll view
    private let blurView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupWelcomeView()
        setupCreateButton()
        updateButtonBackgroundView(scrollView: scrollView)
    }
    
    /// Add the `scrollView` to the `view` and setup its constraints
    private func setupScrollView() {
        view.addSubview(scrollView)
        view.addSubview(buttonBackgroundView)
        scrollView.delegate = self
        scrollView.anchor
            .topToSuperview()
            .trailingToSuperview()
            .leadingToSuperview()
            .activate()
        
        scrollView.addSubview(contentView)
        contentView.anchor
            .edgesToSuperview()
            .width(to: scrollView.widthAnchor)
            .height(to: scrollView.heightAnchor, priority: .defaultLow)
            .activate()
        
        buttonBackgroundView.anchor
                   .top(to: scrollView.bottomAnchor)
                   .trailingToSuperview()
                   .bottomToSuperview()
                   .leadingToSuperview()
                   .activate()
    }
    
    /// Add content to the `contentView`
    private func setupWelcomeView() {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
        titleLabel.text = "Welcome to\nGradeability"
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "To get started, you first need to create a new Term."
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.anchor
            .topToSuperview(constant: 50, toSafeArea: true)
            .trailingToSuperview(constant: -50, toSafeArea: true)
            .leadingToSuperview(constant: 50, toSafeArea: true)
            .activate()
        
        descriptionLabel.anchor
            .top(to: titleLabel.bottomAnchor, constant: 20)
            .trailing(to: titleLabel.trailingAnchor)
            .bottomToSuperview()
            .leading(to: titleLabel.leadingAnchor)
            .activate()
    }
    
    /// Add the `buttonBackgroundView` and setup the button and `blurView`
    private func setupCreateButton() {
        let createButton = UIButton()
        createButton.setTitle("Create Term", for: .normal)
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: createButton.titleLabel?.font.pointSize ?? 17)
        createButton.setTitleColor(.white, for: .normal)
        createButton.layer.cornerRadius = 10
        createButton.clipsToBounds = true
        createButton.backgroundColor = .systemBlue
        
        buttonBackgroundView.addSubview(blurView)
        buttonBackgroundView.addSubview(createButton)
        
        blurView.anchor.edgesToSuperview().activate()
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = buttonBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        blurView.alpha = 0
        
        createButton.anchor
            .centerXToSuperview()
            .topToSuperview(constant: 50)
            .trailingToSuperview(constant: -50, toSafeArea: true)
            .bottomToSuperview(constant: -50, toSafeArea: true)
            .leadingToSuperview(constant: 50, toSafeArea: true)
            .height(constant: 50)
            .activate()
    }
    
    /// Set `blurView`'s alfa to 1 or 0 depending on scroll position
    /// - Parameter scrollView: UIScrollView that's been scrolled
    func updateButtonBackgroundView(scrollView: UIScrollView) {
        let scrollViewHeight = scrollView.frame.height
        let contentHeight = scrollView.contentSize.height
        guard contentHeight > scrollViewHeight else { return }
        
        var alpha: CGFloat = 0
        let contentOffset = scrollView.contentOffset.y
        
        if contentHeight > scrollViewHeight + contentOffset {
            alpha = 1
        } else {
            alpha = 0
        }
        
        UIView.animate(withDuration: 0.1) {
            self.blurView.alpha = alpha
        }
    }

}

extension WelcomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateButtonBackgroundView(scrollView: scrollView)
    }
}
