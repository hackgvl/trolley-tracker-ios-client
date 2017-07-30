//
//  ApplicationController.swift
//  TrolleyTracker
//
//  Created by Austin on 3/22/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ApplicationController: FunctionController {

    private let client: APIClient
    private let dependencies: AppDependencies

    var childControllers = [FunctionController]()

    override init() {

        let c = APIClient(session: URLSession.shared)
        self.client = c

        self.dependencies = AppDependencies(client: c)
    }

    func install(in window: UIWindow) {

        let container = ContainerController(dependencies: dependencies)
        let containerVC = container.prepare()
        childControllers.append(container)

        let schedule = ScheduleController(dependencies: dependencies)
        let scheduleVC = schedule.prepare()
        childControllers.append(schedule)

        let more = MoreController()
        let moreVC = more.prepare()
        childControllers.append(more)

        let tabC = UITabBarController()
        tabC.viewControllers = [containerVC, scheduleVC, moreVC]

        window.rootViewController = tabC

        window.makeKeyAndVisible()
    }
}
