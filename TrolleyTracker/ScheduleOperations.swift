//
//  ScheduleOperations.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/13/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation
import SwiftyJSON

class OperationQueues {
    
    static let networkQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        return queue
    }()
    
    static let computationQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        return queue
    }()
}


//==================================================================
// MARK: - Network
//==================================================================

class LoadRoutesFromNetworkOperation: ConcurrentOperation {

//    let resultsPointer: UnsafeMutablePointer<[JSON]>
    let results: Box<[JSON]>

//    init(results: UnsafeMutablePointer<[JSON]>) {
    init(inout results: Box<[JSON]>) {
        self.results = results
    }
    
    override func execute() {
        
        let request = TrolleyRequests.Routes
        request.responseJSON { (response) -> Void in
            guard let resultValue = response.result.value else { self.finish(); return; }
            guard let jsonArray = JSON(resultValue).array else { self.finish(); return; }

            self.results.value?.appendContentsOf(jsonArray)
            self.finish()
        }
    }
}

class LoadSchedulesFromNetworkOperation: ConcurrentOperation {
    
    let results: Box<[JSON]>
    
    init(inout boxedResults: Box<[JSON]>) {
        self.results = boxedResults
    }
    
    override func execute() {
        
        let request = TrolleyRequests.RouteSchedules()
        request.responseJSON { (response) -> Void in
            guard let resultValue = response.result.value else { self.finish(); return; }
            guard let jsonArray = JSON(resultValue).array else { self.finish(); return; }

            self.results.value?.appendContentsOf(jsonArray)
            self.finish()
        }
    }
}

//==================================================================
// MARK: - Aggregation
//==================================================================

class AggregateSchedulesOperation: ConcurrentOperation {
    
    private let routes: Box<[JSON]>
    private let schedules: Box<[JSON]>
    
    var routeSchedules = [RouteSchedule]() // <-- Return value
    
    init(inout schedules: Box<[JSON]>, inout routes: Box<[JSON]>) {
        self.schedules = schedules
        self.routes = routes
    }
    
    override func execute() {
        
        guard let schedules = self.schedules.value else { self.finish(); return }
        guard let routes = self.routes.value else { self.finish(); return }
        
        // Aggregate schedules by route ID (i.e. there should only be one schedule per route, but with multiple times per schedule)
        // e.g. RouteID: 1, RouteName: "Main to Flour Field", times: ["Sunday 4-6", "Friday 6-10"]
        // For each schedule, add it's name from the Route list we loaded earlier. If we can't find a name, insert some default.
        for route in routes {
            // for each route
            // -- find any matching schedules
            var routeTimes = [RouteTime]()
            for schedule in schedules {
                guard let routeTime = RouteTime(json: schedule) else { continue }
                // -- for any schedules that match, create a route time object from that schedule and add it to an array
                routeTimes.append(routeTime)
            }
            
            // -- if matching schedules were found, create a new RouteSchedule object for them
            if routeTimes.count > 0 {
                guard let name = route[RouteScheduleJSONKeys.Description.rawValue].string else { continue }
                self.routeSchedules.append(RouteSchedule(name: name, times: routeTimes))
            }
        }
        
        self.finish()
    }
}

//==================================================================
// MARK: - Local Storage
//==================================================================

private let UserDefaultsRouteScheduleKey = "UserDefaultsRouteScheduleKey"

class SaveSchedulesOperation: NSOperation {
    
    private let schedules: [RouteSchedule]
    
    init(schedules: [RouteSchedule]) {
        self.schedules = schedules
    }
    
    override func main() {
        let scheduleDictionaries = schedules.map { $0.dictionaryRepresentation() }
        NSUserDefaults.standardUserDefaults().setObject(scheduleDictionaries, forKey: UserDefaultsRouteScheduleKey)
    }
}

class LoadLocalSchedulesOperation: NSOperation {
    
    var loadedSchedules: [RouteSchedule]?
    
    override func main() {
        if let dictionaries = NSUserDefaults.standardUserDefaults().objectForKey(UserDefaultsRouteScheduleKey) as? [[String : AnyObject]] {
            var schedules = [RouteSchedule]()
            for dictionary in dictionaries {
                guard let schedule = RouteSchedule(dictionary: dictionary) else { continue }
                schedules.append(schedule)
            }
            loadedSchedules = schedules
        }
    }
}