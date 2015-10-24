//
//  FormatSchedulesByRouteOperation.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/24/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class FormatSchedulesByRouteOperation: NSOperation {

    var scheduleViews = [UIView]() // <-- Return value
    
    private let schedules: [RouteSchedule]
    
    init(schedules: [RouteSchedule]) {
        self.schedules = schedules
    }
    
    override func main() {
        
        var groupedSchedules = [GroupedRouteSchedule]()
        
        for schedule in schedules {
            
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
            
            groupedSchedules.append(GroupedRouteSchedule(routeName: schedule.name, groupedTimes: groupedTimes))
        }
        
        for groupedSchedule in groupedSchedules {
            
            // Display name
            scheduleViews.append(HeadingLabel(text: groupedSchedule.routeName))
            
            for groupedRouteTime in groupedSchedule.groupedTimes {
                scheduleViews.append(SubHeadingLabel(text: groupedRouteTime.day))
                for time in groupedRouteTime.times {
                    scheduleViews.append(BodyLabel(text: "• " + time))
                }
                scheduleViews.append(SpacerView(height: 6))
            }
            
            scheduleViews.append(SpacerView(height: 14))
        }
    }
}

private struct GroupedRouteSchedule {
    let routeName: String
    var groupedTimes: [GroupedRouteTime]
}

private struct GroupedRouteTime {
    let day: String
    var times: [String]
}