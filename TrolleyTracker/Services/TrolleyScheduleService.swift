//
//  TrolleyScheduleService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation


class TrolleyScheduleService {
    
    typealias LoadScheduleCompletion = (_ schedules: [RouteSchedule]) -> Void
    private let client: APIClient
    
    init(client: APIClient) {
        self.client = client
    }
    
    func loadTrolleySchedules(_ completion: @escaping LoadScheduleCompletion) {
        
        // check user defaults (should probably go in an operation)
        let localSchedulesOperation = LoadLocalSchedulesOperation()
        localSchedulesOperation.completionBlock = { [weak localSchedulesOperation] in
            guard let schedules = localSchedulesOperation?.loadedSchedules else { return }
            DispatchQueue.main.async {
                completion(schedules)
            }
        }
        OperationQueue.main.addOperation(localSchedulesOperation)
        
        // load from network
        loadSchedulesFromNetwork(completion)
    }
    
    fileprivate func loadSchedulesFromNetwork(_ completion: @escaping LoadScheduleCompletion) {
        
        // Load all Routes so we have names for the RouteSchedules (associated by RouteID)
        var routes = Box<[JSON]>(value: [JSON]())
        let routesOperation = LoadRoutesFromNetworkOperation(results: &routes, client: client)
        
        // Load all schedules
        var schedules = Box<[JSON]>(value: [JSON]())
        let schedulesOperation = LoadSchedulesFromNetworkOperation(boxedResults: &schedules, client: client)
        
        // Aggregate schedules, assigning names from the Routes we retrieved
        let aggregateOperation = AggregateSchedulesOperation(schedules: &schedules, routes: &routes)
        aggregateOperation.addDependency(schedulesOperation)
        aggregateOperation.addDependency(routesOperation)
        aggregateOperation.completionBlock = { [weak aggregateOperation] in
            guard let routeSchedules = aggregateOperation?.routeSchedules , routeSchedules.count > 0 else { return }
            DispatchQueue.main.async {
                OperationQueue.main.addOperation(SaveSchedulesOperation(schedules: routeSchedules))
                completion(routeSchedules)
            }
        }
        
        OperationQueues.networkQueue.addOperation(routesOperation)
        OperationQueues.networkQueue.addOperation(schedulesOperation)
        OperationQueues.computationQueue.addOperation(aggregateOperation)
    }
}
