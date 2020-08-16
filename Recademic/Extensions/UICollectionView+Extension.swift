//
//  UICollectionView+Extension.swift
//  Recademic
//
//  Created by Ignacio Paradisi on 6/11/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    /// Registers a UITableViewCell into a UITableView
    /// - Parameter _: UITableViewCell subclass to be registered
    func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.reusableIdentifier)
    }
    
    /// Dequeues cell if UITableViewCell subclass conforms ReusableView protocol
    /// - Parameter indexPath: IndexPath of UITableViewCell
    /// - Returns: UITableViewCell dequeued
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reusableIdentifier)")
        }
        return cell
    }
}
