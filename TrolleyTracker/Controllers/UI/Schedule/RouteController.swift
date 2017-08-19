//
//  RouteController.swift
//  TrolleyTracker
//
//  Created by Austin on 8/2/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class RouteController: FunctionController {

    typealias Dependencies = HasModelController

    private let routeID: Int
    private let context: UIViewController
    private let dependencies: Dependencies

    private let viewController = RouteDetailViewController()
    private let delegate = TrolleyMapViewDelegate()

    init(routeID: Int,
         presentationContext: UIViewController,
         dependencies: Dependencies) {
        self.routeID = routeID
        self.dependencies = dependencies
        self.context = presentationContext
    }

    func present() {
        guard let nav = context.navigationController else {
            fatalError()
        }

        delegate.shouldShowCallouts = true

        nav.pushViewController(viewController,
                               animated: true)

        viewController.mapView.delegate = delegate
        viewController.mapView.setRegionToDowntownGreenville()

        loadRoute()
    }

    private func loadRoute() {

        viewController.setWaitingUI(visible: true)

        dependencies.modelController.loadTrolleyRoute(routeID) { routes in
            self.viewController.setWaitingUI(visible: false)
            guard let route = routes.first else { return }
            self.viewController.display(route: route)
        }
    }
}
