//
//  ModelController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/17/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class ModelController {
    
    // MARK: - Interface
    
    typealias LoadScheduleCompletion = (_ schedules: [RouteSchedule]) -> Void

    init(apiClient client: APIClient) {
        self.scheduleSerivce = TrolleyScheduleService(client: client)
        self.routeSerice = TrolleyRouteServiceLive(client: client)
        self.locationService = TrolleyLocationServiceLive(client: client)

        locationService.trolleyObservers.add { trolleys in
            self.trolleyObservers.notify(trolleys)
        }
        locationService.trolleyPresentObservers.add { present in
            self.trolleyPresentObservers.notify(present)
        }
    }
    
    var trolleyObservers = ObserverSet<[Trolley]>()
    var trolleyPresentObservers = ObserverSet<Bool>()
    
    func loadTrolleyRoutes(_ completion: @escaping LoadTrolleyRouteCompletion) {
        routeSerice.loadTrolleyRoutes(completion)
    }
    
    func loadTrolleyRoute(_ routeID: Int, completion: @escaping LoadTrolleyRouteCompletion) {
        routeSerice.loadTrolleyRoute(routeID, completion: completion)
    }
    
    func loadTrolleySchedules(_ completion: @escaping LoadScheduleCompletion) {
        scheduleSerivce.loadTrolleySchedules(completion)
    }
    
    func startTrackingTrolleys() {
        locationService.startTrackingTrolleys()
    }
    
    func stopTrackingTrolleys() {
        locationService.stopTrackingTrolley()
    }
    
    // MARK: - Implementation
    
    private let scheduleSerivce: TrolleyScheduleService
    private let locationService: TrolleyLocationService
    private let routeSerice: TrolleyRouteService
}
