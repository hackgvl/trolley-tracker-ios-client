//
//  ScheduleSorting.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/31/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

extension Array where Element == RouteSchedule {

    func groupedByRoute() -> [ScheduleSection] {

        var groupedSchedules = [GroupedRouteSchedule]()

        for schedule in self {

            var groupedTimes = [GroupedRouteTime]()

            for time in schedule.times {
                // Check to see if we have handled this day
                if groupedTimes.filter({ $0.day == time.day }).count > 0 { continue }

                // Find all matching times
                let matchingTimes = schedule.times.filter { $0.day == time.day }

                // Convert them to an array of strings
                let timeStrings = matchingTimes.map { $0.time }

                // Create a GroupedRouteTime object
                groupedTimes.append(GroupedRouteTime(day: time.day, times: timeStrings))
            }

            groupedSchedules.append(GroupedRouteSchedule(routeName: schedule.name, routeID: schedule.ID, groupedTimes: groupedTimes))
        }


        var scheduleSections = [ScheduleSection]()

        for groupedSchedule in groupedSchedules {

            var scheduleItems = [ScheduleItem]()

            for groupedRouteTime in groupedSchedule.groupedTimes {
                var scheduleTimes = [String]()
                for time in groupedRouteTime.times {
                    scheduleTimes.append(time)
                }
                scheduleItems.append(ScheduleItem(title: groupedRouteTime.day, routeID: groupedSchedule.routeID, times: scheduleTimes, selectable: false))
            }
            scheduleSections.append(ScheduleSection(title: groupedSchedule.routeName, items: scheduleItems, selectable: true))
        }

        return scheduleSections
    }

    func groupedByDay() -> [ScheduleSection] {

        // Create a dictionary of all the days we might show
        var days = [Day : [Route]]()
        for day in Day.allDays {
            days[day] = [Route]()
        }

        // Create a list of all Routes and add them to the days dictionary
        for schedule in self {
            for time in schedule.times {
                guard let newDay = Day(rawValue: time.day) else { continue }
                days[newDay]?.append(Route(name: schedule.name, ID: schedule.ID, time: time.time))
            }
        }

        // Group the routes into GroupedRoute objects
        var flattenedDays = [Day : [GroupedRoute]]()
        for day in Day.allDays {
            flattenedDays[day] = [GroupedRoute]()
        }

        for (day, routes) in days {
            for route in routes {
                // Check to see if we have already handled this route
                if let matching = flattenedDays[day]?.filter({ $0.name == route.name }), matching.count > 0 { continue }

                // Find all matching routes
                let matchingRoutes = routes.filter { $0.name == route.name }

                // Convert them into an array of strings
                let times = matchingRoutes.map { $0.time }

                // Create a GroupedRoute object
                flattenedDays[day]?.append(GroupedRoute(name: route.name, ID: route.ID, times: times))
            }
        }

        // Create Schedule Display items
        let sections: [ScheduleSection] = Day.sortedDays.flatMap { day in

            // Don't display days with no routes
            guard let routes = flattenedDays[day] , !routes.isEmpty else { return nil }

            let scheduleItems = routes.map { ScheduleItem(route: $0) }
            return ScheduleSection(title: day.rawValue,
                                   items: scheduleItems,
                                   selectable: false)
        }

        return sections
    }
}

private extension ScheduleItem {
    init(route: GroupedRoute) {
        self.routeID = route.ID
        self.times = route.times
        self.title = route.name
        self.selectable = true
    }
}

private struct GroupedRouteSchedule {
    let routeName: String
    let routeID: Int
    var groupedTimes: [GroupedRouteTime]
}

private struct GroupedRouteTime {
    let day: String
    var times: [String]
}

private enum Day: String {
    case Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

    static var allDays: [Day] {
        get { return [.Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday, .Sunday] }
    }

    static var sortedDays: [Day] {
        get { return Day.allDays }
    }
}

private struct GroupedRoute {
    let name: String
    let ID: Int
    var times: [String]
}

private struct Route: Hashable {
    let name: String
    let ID: Int
    let time: String
    var hashValue: Int { get { return name.hashValue } }
}

private func ==(lhs: Route, rhs: Route) -> Bool {
    return lhs.name == rhs.name
}

