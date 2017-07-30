//
//  ContainerController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ContainerController: FunctionController {

    typealias Dependencies = HasLocationService & HasRouteService

    private let dependencies: Dependencies
    private let viewController: ContainerViewController

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewController = ContainerViewController()
    }

    func prepare() -> UIViewController {
        return viewController
    }
}

