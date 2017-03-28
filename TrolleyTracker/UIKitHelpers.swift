//
//  UIKitHelpers.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

extension UICollectionView {

    public func dequeueCell<T>(ofType type: T.Type,
                            identifier: String? = nil,
                            for indexPath: IndexPath) -> T where T: UICollectionViewCell {

        let cellId = identifier ?? String(describing: type)
        let cell = dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)

        guard let typedCell = cell as? T else {
            fatalError("Dequeued cell with identifier: \(String(describing: identifier)), " +
                "expecting it to be of type: \(type), " +
                "but instead it was: \(cell.self)")
        }

        return typedCell
    }

    public func registerCell<T>(ofType type: T.Type) {
        let identifier = String(describing: type)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellWithReuseIdentifier: identifier)
    }
}

extension UITableView {

    public func dequeueCell<T>(ofType type: T.Type,
                            identifier: String? = nil,
                            for indexPath: IndexPath) -> T where T: UITableViewCell {

        let cellId = identifier ?? String(describing: type)
        let cell = dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        guard let typedCell = cell as? T else {
            fatalError("Dequeued cell with identifier: \(String(describing: identifier)), " +
                "expecting it to be of type: \(type), " +
                "but instead it was: \(cell.self)")
        }

        return typedCell
    }

    public func registerCell<T>(ofType type: T.Type) {
        let identifier = String(describing: type)
        let nib = UINib(nibName: identifier, bundle: nil)
        register(nib, forCellReuseIdentifier: identifier)
    }
}

