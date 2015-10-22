//
//  TrolleyScheduleService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation
import SwiftyJSON

class TrolleyScheduleService {
    
    typealias LoadScheduleCompletion = (schedules: [RouteSchedule]) -> Void
    
    static var sharedService = TrolleyScheduleService()
    
    init() {

    }
    
    func loadTrolleySchedules(completion: LoadScheduleCompletion) {
        
        // check user defaults (should probably go in an operation)
        let localSchedulesOperation = LoadLocalSchedulesOperation()
        localSchedulesOperation.completionBlock = { [weak localSchedulesOperation] in
            guard let schedules = localSchedulesOperation?.loadedSchedules else { return }
            dispatch_async(dispatch_get_main_queue()) {
                completion(schedules: schedules)
            }
        }
        NSOperationQueue.mainQueue().addOperation(localSchedulesOperation)
        
        // load from network
        loadSchedulesFromNetwork(completion)
    }
    
    private func loadSchedulesFromNetwork(completion: LoadScheduleCompletion) {
        
        // Load all Routes so we have names for the RouteSchedules (associated by RouteID)
        var routes = Box<[JSON]>(value: [JSON]())
        let routesOperation = LoadRoutesFromNetworkOperation(results: &routes)
        
        // Load all schedules
        var schedules = Box<[JSON]>(value: [JSON]())
        let schedulesOperation = LoadSchedulesFromNetworkOperation(boxedResults: &schedules)
        
        // Aggregate schedules, assigning names from the Routes we retrieved
        let aggregateOperation = AggregateSchedulesOperation(schedules: &schedules, routes: &routes)
        aggregateOperation.addDependency(schedulesOperation)
        aggregateOperation.addDependency(routesOperation)
        aggregateOperation.completionBlock = { [weak aggregateOperation] in
            guard let routeSchedules = aggregateOperation?.routeSchedules else { return }
            dispatch_async(dispatch_get_main_queue()) {
                NSOperationQueue.mainQueue().addOperation(SaveSchedulesOperation(schedules: routeSchedules))
                completion(schedules: routeSchedules)
            }
        }
        
        OperationQueues.networkQueue.addOperation(routesOperation)
        OperationQueues.networkQueue.addOperation(schedulesOperation)
        OperationQueues.computationQueue.addOperation(aggregateOperation)
    }
}
