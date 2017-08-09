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
    
    private func loadSchedulesFromNetwork(_ completion: @escaping LoadScheduleCompletion) {
        
        // Load all Routes so we have names for the RouteSchedules (associated by RouteID)
        let routesOperation = LoadRoutesFromNetworkOperation(client: client)
        
        // Load all schedules
        let schedulesOperation = LoadSchedulesFromNetworkOperation(client: client)
        
        // Aggregate schedules, assigning names from the Routes we retrieved
        let aggregateOperation = AggregateSchedulesOperation()
        aggregateOperation.completionBlock = { [weak aggregateOperation] in
            guard let routeSchedules = aggregateOperation?.routeSchedules , routeSchedules.count > 0 else { return }
            DispatchQueue.main.async {
                OperationQueue.main.addOperation(SaveSchedulesOperation(schedules: routeSchedules))
                completion(routeSchedules)
            }
        }

        let adapterOp = BlockOperation {
            aggregateOperation.routes = routesOperation.routes
            aggregateOperation.schedules = schedulesOperation.schedules
        }

        adapterOp.addDependency(schedulesOperation)
        adapterOp.addDependency(routesOperation)

        aggregateOperation.addDependency(adapterOp)

        OperationQueues.networkQueue.addOperation(routesOperation)
        OperationQueues.networkQueue.addOperation(schedulesOperation)
        OperationQueues.computationQueue.addOperation(adapterOp)
        OperationQueues.computationQueue.addOperation(aggregateOperation)
    }
}
