//
//  ScheduleDataSource.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/1/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleDataSource: NSObject {

    typealias DisplayRouteAction = (_ routeID: Int) -> Void

    var displayType: ScheduleController.DisplayType = .day

    var displayRouteAction: DisplayRouteAction?

    private var sections: [ScheduleSection] {
        switch displayType {
        case .day: return schedulesByDay
        case .route: return schedulesByRoute
        }
    }

    private var schedulesByDay: [ScheduleSection] = []
    private var schedulesByRoute: [ScheduleSection] = []

    func set(schedules: [RouteSchedule]) {
        schedulesByDay = schedules.groupedByDay()
        schedulesByRoute = schedules.groupedByRoute()
    }

    private func item(at indexPath: IndexPath) -> ScheduleItem {
        return sections[indexPath.section].items[indexPath.row]
    }
}

extension ScheduleDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let item = self.item(at: indexPath)
        let cell = tableView.dequeueCell(ofType: ScheduleViewCell.self, for: indexPath)

        cell.displayItem(item)

        return cell
    }
}

extension ScheduleDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.deqeueView(ofType: ScheduleHeaderView.self)
        let section = sections[section]

        view.tapAction = displayRouteAction
        view.tapAction = displayRouteAction
        view.displaySection(section)

        return view
    }

    func tableView(_ tableView: UITableView,
                   viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }

    func tableView(_ tableView: UITableView,
                   heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.item(at: indexPath)
        guard item.selectable else { return }
        displayRouteAction?(item.routeID)
    }
}
