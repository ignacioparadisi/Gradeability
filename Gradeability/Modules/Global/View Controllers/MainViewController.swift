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
    private var calendarViewController: CalendarViewController?
    private let calendarViewControllerReference = CalendarViewController()
    private var splitViewTrailingAnchor: Anchor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(windowSizeDidChange), name: .windowSizeDidChange, object: nil)
        
        addChild(mainSplitViewController)
        view.addSubview(mainSplitViewController.view)
        
        mainSplitViewController.view.anchor
            .topToSuperview()
            .bottomToSuperview()
            .leadingToSuperview()
            .activate()
        splitViewTrailingAnchor = mainSplitViewController.view.anchor.trailingToSuperview()
        
        setupRightPanel()
        
    }
    
    private func setupRightPanel() {
        if view.frame.size.width > 1300 && calendarViewController == nil {
            splitViewTrailingAnchor.deactivate()
            calendarViewController = calendarViewControllerReference
            addChild(calendarViewController!)
            view.addSubview(calendarViewController!.view)
            calendarViewController!.view.anchor
                .topToSuperview()
                .trailingToSuperview()
                .bottomToSuperview()
                .leading(to: mainSplitViewController.view.trailingAnchor)
                .width(constant: 400)
                .activate()
        } else if view.frame.size.width <= 1300 {
            calendarViewController?.removeFromParent()
            calendarViewController?.view.removeFromSuperview()
            calendarViewController = nil
            splitViewTrailingAnchor.activate()
        }
    }
    
    @objc private func windowSizeDidChange() {
        setupRightPanel()
    }
}
