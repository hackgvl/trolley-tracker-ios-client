//
//  MapController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MapController: FunctionController {

    typealias Dependencies = HasRouteService & HasLocationService

    private let viewController: MapViewController

    init(dependencies: Dependencies) {
        self.viewController = MapViewController()
    }

    func prepare() -> UIViewController {
        return viewController
    }
}
