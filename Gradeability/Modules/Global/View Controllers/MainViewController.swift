//
//  MainViewController.swift
//  Gradeability
//
//  Created by Ignacio Paradisi on 6/10/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    private let mainSplitViewController = MainSplitViewController()
    private let tableViewController: UIViewController = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(mainSplitViewController)
        addChild(tableViewController)
        
        view.addSubview(mainSplitViewController.view)
        view.addSubview(tableViewController.view)
        
        mainSplitViewController.view.anchor
            .topToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        
        tableViewController.view.anchor
            .topToSuperview()
            .trailingToSuperview()
            .bottomToSuperview()
            .leading(to: mainSplitViewController.view.trailingAnchor)
            .width(constant: 500)
            .activate()
    }
}
