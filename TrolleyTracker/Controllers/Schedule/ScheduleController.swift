//
//  ScheduleController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleController: FunctionController {

    typealias Dependencies = HasScheduleService

    private let dependencies: Dependencies
    private let viewController: ScheduleVC

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewController = ScheduleVC()
    }

    func prepare() -> UIViewController {
        return viewController
    }
}
