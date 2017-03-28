//
//  StoryboardHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

extension UIStoryboard {

    static func mapLayersController() -> MapLayersListViewController {
        return more.viewController(of: MapLayersListViewController.self)
    }

    static func mapLayerDetailController(layer: MapLayerItemCollection) -> MapLayerViewController {
        MapLayerViewController.setDependencies(layer)
        return more.viewController(of: MapLayerViewController.self)
    }

    private static var more: UIStoryboard {
        return UIStoryboard(name: "More", bundle: nil)
    }

    private func viewController<T>(of type: T.Type) -> T {
        let identifier = String(describing: type)
        let controller = instantiateViewController(withIdentifier: identifier)
        guard let typed = controller as? T else {
            fatalError()
        }
        return typed
    }
}
