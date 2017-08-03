//
//  ScheduleController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleController: FunctionController {

    enum DisplayType: Int {
        case route, day

        static var all: [DisplayType] {
            return [.route, .day]
        }

        static var `default`: DisplayType {
            return .route
        }
    }

    typealias Dependencies = HasScheduleService & HasRouteService

    private let dependencies: Dependencies
    fileprivate let viewController: ScheduleViewController
    fileprivate let dataSource: ScheduleDataSource

    private var routeController: RouteController?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.dataSource = ScheduleDataSource()
        self.viewController = ScheduleViewController()
    }

    func prepare() -> UIViewController {

        let type = DisplayType.default
        dataSource.displayType = type
        viewController.displayTypeControl.selectedSegmentIndex = type.rawValue
        dataSource.displayRouteAction = displayRoute(_:)

        viewController.tabBarItem.image = #imageLiteral(resourceName: "Schedule")
        viewController.tabBarItem.title = LS.scheduleTitle

        viewController.delegate = self

        let nav = UINavigationController(rootViewController: viewController)

        viewController.tableView.dataSource = dataSource
        viewController.tableView.delegate = dataSource
        loadSchedules()

        return nav
    }

    private func loadSchedules() {
        dependencies.scheduleService.loadTrolleySchedules(handleNewSchedules(_:))
    }

    private func handleNewSchedules(_ schedules: [RouteSchedule]) {
        dataSource.set(schedules: schedules)
        viewController.tableView.reloadData()
    }

    private func displayRoute(_ routeID: Int) {
        routeController = RouteController(routeID: routeID,
                                          presentationContext: viewController,
                                          dependencies: dependencies)
        routeController?.present()
    }
}

extension ScheduleController: ScheduleVCDelegate {

    func didSelectScheduleTypeIndex(_ index: Int) {
        let displayType = ScheduleController.DisplayType(rawValue: index)!
        dataSource.displayType = displayType
        viewController.tableView.reloadData()
    }
}
