//
//  DetailController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class DetailController: FunctionController {

    typealias Dependencies = HasRouteService & HasLocationService

    private let viewController: DetailViewController

    init(dependencies: Dependencies) {
        self.viewController = DetailViewController()
    }

    func prepare() -> UIViewController {
        return viewController
    }
}
