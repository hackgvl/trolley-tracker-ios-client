//
//  ScheduleOperations.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/13/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation


class OperationQueues {
    
    static let networkQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()
    
    static let computationQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()
}


//==================================================================
// MARK: - Network
//==================================================================

class LoadRoutesFromNetworkOperation: ConcurrentOperation {

    let results: Box<[JSON]>
    private let client: APIClient

    init(results: inout Box<[JSON]>, client: APIClient) {
        self.results = results
        self.client = client
    }
    
    override func execute() {

        client.fetchAllRoutes { result in

            defer { self.finish() }

            switch result {
            case .failure: break
            case .success(let data):
                let array = JSON(data).arrayValue
                self.results.value?.append(contentsOf: array)
            }
        }
    }
}

class LoadSchedulesFromNetworkOperation: ConcurrentOperation {
    
    let results: Box<[JSON]>
    private let client: APIClient
    
    init(boxedResults: inout Box<[JSON]>, client: APIClient) {
        self.results = boxedResults
        self.client = client
    }
    
    override func execute() {

        client.fetchRouteSchedules { result in

            defer { self.finish() }

            switch result {
            case .failure:
                break
            case .success(let data):
                let jsonArray = JSON(data).arrayValue
                self.results.value?.append(contentsOf: jsonArray)
            }
        }
    }
}

//==================================================================
// MARK: - Aggregation
//==================================================================

class AggregateSchedulesOperation: ConcurrentOperation {
    
    fileprivate let routes: Box<[JSON]>
    fileprivate let schedules: Box<[JSON]>
    
    var routeSchedules = [RouteSchedule]() // <-- Return value
    
    init(schedules: inout Box<[JSON]>, routes: inout Box<[JSON]>) {
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
            var routeTimes = [RouteTime]()
            // -- find any matching schedules
            let matchingSchedules = schedules.filter { $0["RouteID"].number == route["ID"].number }
            
            for schedule in matchingSchedules {
                guard let routeTime = RouteTime(json: schedule) else { continue }
                // -- for any schedules that match, create a route time object from that schedule and add it to an array
                routeTimes.append(routeTime)
            }
            
            // -- if matching schedules were found, create a new RouteSchedule object for them
            if routeTimes.count > 0 {
                guard let name = route[RouteScheduleJSONKeys.Description.rawValue].string else { continue }
                guard let routeID = route[RouteScheduleJSONKeys.ID.rawValue].int else { continue }
                self.routeSchedules.append(RouteSchedule(name: name, ID: routeID, times: routeTimes))
            }
        }
        
        self.finish()
    }
}

//==================================================================
// MARK: - Local Storage
//==================================================================

private let UserDefaultsRouteScheduleKey = "UserDefaultsRouteScheduleKey"

class SaveSchedulesOperation: Operation {
    
    fileprivate let schedules: [RouteSchedule]
    
    init(schedules: [RouteSchedule]) {
        self.schedules = schedules
    }
    
    override func main() {
        let scheduleDictionaries = schedules.map { $0.dictionaryRepresentation() }
        UserDefaults.standard.set(scheduleDictionaries, forKey: UserDefaultsRouteScheduleKey)
    }
}

class LoadLocalSchedulesOperation: Operation {
    
    var loadedSchedules: [RouteSchedule]?
    
    override func main() {
        if let dictionaries = UserDefaults.standard.object(forKey: UserDefaultsRouteScheduleKey) as? [[String : AnyObject]] {
            var schedules = [RouteSchedule]()
            for dictionary in dictionaries {
                guard let schedule = RouteSchedule(dictionary: dictionary) else { continue }
                schedules.append(schedule)
            }
            loadedSchedules = schedules
        }
    }
}
