//
//  UIKitHelpers.swift
//  Created by Austin on 5/6/17.
//

import UIKit

extension UICollectionView {

    var flowLayout: UICollectionViewFlowLayout? {
        return collectionViewLayout as? UICollectionViewFlowLayout
    }

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

    public func dequeueReusableView<T>(ofType type: T.Type,
                                    ofKind kind: String,
                                    identifier: String? = nil,
                                    at indexPath: IndexPath) -> T where T: UICollectionReusableView {
        let id = identifier ?? String(describing: type)
        let view = dequeueReusableSupplementaryView(ofKind: kind,
                                                    withReuseIdentifier: id,
                                                    for: indexPath)

        guard let typedView = view as? T else {
            fatalError()
        }

        return typedView
    }

    public func registerCell<T>(ofType type: T.Type) where T: UICollectionViewCell {
        let identifier = String(describing: type)
        register(type, forCellWithReuseIdentifier: identifier)
    }

    public func registerSupplementaryView<T>(ofType type: T.Type,
                                          ofKind kind: String) where T: UICollectionReusableView {
        let identifier = String(describing: type)
        register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
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

    public func deqeueView<T>(ofType type: T.Type,
                              identifier: String? = nil) -> T where T: UITableViewHeaderFooterView {
        let viewId = identifier ?? String(describing: type)
        let view = dequeueReusableHeaderFooterView(withIdentifier: viewId)

        guard let typedView = view as? T else {
            fatalError("Dequeued cell with identifier: \(String(describing: viewId)), " +
                "expecting it to be of type: \(type), " +
                "but instead it was: \(String(describing: view.self))")
        }

        return typedView
    }

    public func registerCell<T>(ofType type: T.Type) where T: UITableViewCell {
        let identifier = String(describing: type)
        register(type, forCellReuseIdentifier: identifier)
    }

    public func registerView<T>(ofType type: T.Type) where T: UITableViewHeaderFooterView {
        let identifier = String(describing: type)
        register(type, forHeaderFooterViewReuseIdentifier: identifier)
    }
}
