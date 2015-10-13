//
//  TrolleyScheduleService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

class TrolleyScheduleService {
    
    private let UserDefaultsRouteScheduleKey = "UserDefaultsRouteScheduleKey"
    
    typealias LoadScheduleCompletion = (schedules: [RouteSchedule]) -> Void
    
    static var sharedService = TrolleyScheduleService()
    
    func loadTrolleySchedules(completion: LoadScheduleCompletion) {
        
        // check user defaults (should probably go in an operation)
        if let dictionaries = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsRouteScheduleKey) as? [[String : AnyObject]] {
            var schedules = [RouteSchedule]()
            for dictionary in dictionaries {
                guard let schedule = RouteSchedule(dictionary: dictionary) else { continue }
                schedules.append(schedule)
            }
            completion(schedules: schedules)
        }
        
        // load from network
        let request = TrolleyRequests.RouteSchedules()
        request.responseJSON { (request, response, result) -> Void in
            guard let json = result.value else { return }
            
        }
    }
    
    private func loadSchedulesFromNetwork() {
        
        // Operations might be useful here
        
        // Load all Routes so we have names for the RouteSchedules (associated by RouteID)
        
        // Load all schedules
        
        // Aggregate schedules by route ID (i.e. there should only be one schedule per route, but with multiple times per schedule)
        // e.g. RouteID: 1, RouteName: "Main to Flour Field", times: ["Sunday 4-6", "Friday 6-10"]
        
        // For each schedule, add it's name from the Route list we loaded earlier. If we can't find a name, insert some default.
    }
}
