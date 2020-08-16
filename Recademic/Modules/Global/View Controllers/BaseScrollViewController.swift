//
//  BaseScrollViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class BaseScrollViewController: UIViewController {
    /// ScrollView where the views are placed
    private let scrollView = UIScrollView()
    /// View that contains all the subviews. All subviews should be held for the `contentView` instead of the `scrollView`
    let contentView = UIView()
    
    // MARK: Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    /// Setup the navigation bar
    func setupNavigationBar() {
    }
    
    /// Setup the view
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor.edgesToSuperview().activate()
        contentView.anchor
            .edgesToSuperview()
            .width(to: scrollView.widthAnchor)
            .height(to: scrollView.heightAnchor, priority: .defaultLow)
            .activate()
    }
}
