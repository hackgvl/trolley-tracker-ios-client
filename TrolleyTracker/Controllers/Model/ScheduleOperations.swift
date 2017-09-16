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

    var routes: [_APIRoute]?
    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }
    
    override func execute() {

        client.fetchAllRoutes { result in

            switch result {
            case .failure: break
            case .success(let data):
                let decoder = JSONDecoder()
                self.routes = try? decoder.decode([_APIRoute].self, from: data)
            }

            self.finish()
        }
    }
}

class LoadSchedulesFromNetworkOperation: ConcurrentOperation {
    
    var schedules: [_APIRouteSchedule]?
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    override func execute() {

        client.fetchRouteSchedules { result in

            switch result {
            case .failure:
                break
            case .success(let data):
                let decoder = JSONDecoder()
                self.schedules = try? decoder.decode([_APIRouteSchedule].self, from: data)
            }

            self.finish()
        }
    }
}

//==================================================================
// MARK: - Aggregation
//==================================================================

class AggregateSchedulesOperation: ConcurrentOperation {
    
    var routes: [_APIRoute]?
    var schedules: [_APIRouteSchedule]?
    
    var routeSchedules = [RouteSchedule]() // <-- Return value
    
    override func execute() {
        
        guard let schedules = schedules else { finish(); return }
        guard let routes = routes else { finish(); return }
        
        // Aggregate schedules by route ID (i.e. there should only be one schedule per route, but with multiple times per schedule)
        // e.g. RouteID: 1, RouteName: "Main to Flour Field", times: ["Sunday 4-6", "Friday 6-10"]
        // For each schedule, add it's name from the Route list we loaded earlier. If we can't find a name, insert some default.
        for route in routes {
            
            // for each route
            var routeTimes = [RouteTime]()
            // -- find any matching schedules
            let matchingSchedules = schedules.filter { $0.RouteID == route.ID }
            
            for schedule in matchingSchedules {
                // -- for any schedules that match,
                // create a route time object from that schedule
                // and add it to an array
                let routeTime = RouteTime(rawSchedule: schedule)
                routeTimes.append(routeTime)
            }
            
            // -- if matching schedules were found, create a new RouteSchedule object for them
            if routeTimes.count > 0 {
                let name = route.Description
                let routeID = route.ID
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
    
    private let schedules: [RouteSchedule]
    
    init(schedules: [RouteSchedule]) {
        self.schedules = schedules
    }
    
    override func main() {

        let encoder = JSONEncoder()
        let datas = schedules.flatMap {
            try? encoder.encode($0)
        }

        let key = UserDefaultsRouteScheduleKey
        let defaults = UserDefaults.standard

        defaults.set(datas, forKey: key)
    }
}

class LoadLocalSchedulesOperation: Operation {
    
    var loadedSchedules: [RouteSchedule]?
    
    override func main() {

        let key = UserDefaultsRouteScheduleKey
        let defaults = UserDefaults.standard

        guard let datas = defaults.array(forKey: key) as? [Data] else {
            return
        }

        let decoder = JSONDecoder()
        loadedSchedules = datas.flatMap {
            try? decoder.decode(RouteSchedule.self, from: $0)
        }
    }
}
