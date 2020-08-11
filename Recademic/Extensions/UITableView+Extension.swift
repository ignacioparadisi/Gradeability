//
//  UITableView+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 5/29/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UITableView {
    
    /// Registers a UITableViewCell into a UITableView
    /// - Parameter _: UITableViewCell subclass to be registered
    func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    /// Dequeues cell if UITableViewCell subclass conforms ReusableView protocol
    /// - Parameter indexPath: IndexPath of UITableViewCell
    /// - Returns: UITableViewCell dequeued
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }
        return cell
    }
}

extension UITableViewCell {
    
    /// Adds a hover gesture to the cell
    func addHoverGesture() {
        let hoverGesture = UIHoverGestureRecognizer(target: self, action: #selector(setHoverColor(_:)))
        contentView.addGestureRecognizer(hoverGesture)
    }
    
    /// Set the background color of the cell when hovering over it
    /// - Parameter gesture: Hover gesture
    @objc private func setHoverColor(_ gesture: UIHoverGestureRecognizer) {
        switch gesture.state {
        case .began, .changed:
            contentView.backgroundColor = .systemGray2
        case .ended:
            contentView.backgroundColor = .clear
        default:
            break
        }
    }
}
