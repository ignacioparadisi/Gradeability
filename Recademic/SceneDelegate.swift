//
//  SceneDelegate.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/27/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupToolbarIfNeeded(scene: windowScene)
        setupWindowSize(scene: windowScene)
        window = UIWindow(windowScene: windowScene)
//        #if targetEnvironment(macCatalyst)
        window?.rootViewController = MainSplitViewController()
//        #else
//        window?.rootViewController = MainTabBarController()
//        #endif
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        CoreDataManager.shared.saveContext()
    }
    
    /// Send notification when window size changes
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        NotificationCenter.default.post(name: .windowSizeDidChange, object: nil)
    }

}

// MARK: - Custom Functions
extension SceneDelegate {
    /// Adds the toolbar to the mac app
    /// - Parameter scene: Window Scene of the app
    private func setupToolbarIfNeeded(scene: UIWindowScene) {
        #if targetEnvironment(macCatalyst)
        let toolbarIdentifier = "ToolbarIdentifier"
        if let titlebar = scene.titlebar {
            let toolbar = NSToolbar(identifier: toolbarIdentifier)
            toolbar.delegate = self
            toolbar.allowsUserCustomization = false
            titlebar.toolbar = toolbar
            titlebar.titleVisibility = .hidden
        }
        #endif
    }
    
    private func setupWindowSize(scene: UIWindowScene) {
        scene.sizeRestrictions?.minimumSize = CGSize(width: 768.0, height: 768.0)
        scene.sizeRestrictions?.maximumSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    }
}

// MARK: - NSToolbarDelegate
#if targetEnvironment(macCatalyst)
extension SceneDelegate: NSToolbarDelegate {
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.showAllTerms, .addNote]
    }
    
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.showAllTerms, .flexibleSpace, .addNote]
    }
    
    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        if itemIdentifier == .showAllTerms {
            let barButton = UIBarButtonItem(title: "All Terms", style: .plain, target: self, action: #selector(showAllTerms))
            let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButton)
            item.isBordered = true
            item.toolTip = "Show All Terms"
            item.label = ""
            return item
        } else if itemIdentifier == .addNote {
            let barButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: nil)
            let item = NSToolbarItem(itemIdentifier: itemIdentifier, barButtonItem: barButton)
            item.isBordered = true
            item.toolTip = "Add Note"
            item.label = "Add Note"
            return item
        }
        return nil
    }
    
    /// Present `GradablesViewController` for showing all Terms
    @objc private func showAllTerms() {
        if let topViewController = window?.rootViewController {
            let termsViewModel = TermsViewModel()
            let viewController = TermsViewController(viewModel: termsViewModel)
            topViewController.present(UINavigationController(rootViewController: viewController), animated: true)
        }
    }
}
#endif

