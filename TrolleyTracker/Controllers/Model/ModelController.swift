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
        self.scheduleService = TrolleyScheduleService(client: client)
        self.routeService = TrolleyRouteServiceLive(client: client)
        self.locationService = TrolleyLocationServiceLive(client: client)

        locationService.trolleyObservers.add { trolleys in
            self.updateTrolleys(with: trolleys)
        }
    }
    
    var trolleyObservers = ObserverSet<[Trolley]>()

    func loadTrolleyRoutes(_ completion: @escaping LoadTrolleyRouteCompletion) {
        routeService.loadTrolleyRoutes { routes in
            completion(routes)
            self.updateTrolleys(with: self.lastTrolleys)
        }
    }
    
    func loadTrolleyRoute(_ routeID: Int, completion: @escaping LoadTrolleyRouteCompletion) {
        routeService.loadTrolleyRoute(routeID) { routes in
            completion(routes)
            self.updateTrolleys(with: self.lastTrolleys)
        }
    }
    
    func loadTrolleySchedules(_ completion: @escaping LoadScheduleCompletion) {
        scheduleService.loadTrolleySchedules(completion)
    }
    
    func startTrackingTrolleys() {
        locationService.startTrackingTrolleys()
    }
    
    func stopTrackingTrolleys() {
        locationService.stopTrackingTrolley()
    }

    func trolleys(for route: TrolleyRoute) -> [Trolley] {
        return links[route]?.trolleys ?? []
    }

    func route(for trolley: Trolley) -> TrolleyRoute? {
        return links[trolley]
    }
    
    // MARK: - Implementation
    
    private let scheduleService: TrolleyScheduleService
    private let locationService: TrolleyLocationService
    private let routeService: TrolleyRouteService

    private var links: [TrolleyRouteLink] = []
    private var lastTrolleys: [Trolley] = []

    private func updateTrolleys(with trolleys: [Trolley]) {

        // TODO: Remove this line, Trolley AnnotationView should be reloaded if tintColor has changed
        guard routeService.currentActiveRoutes.count > 0 else { return }

        lastTrolleys = trolleys
        updateLinks(trolleys: trolleys)
        let linkedTrolleys = links.trolleys
        let unlinkedTrolleys = trolleys.subtract(linkedTrolleys)
        let allTrolleys = linkedTrolleys + unlinkedTrolleys
        trolleyObservers.notify(allTrolleys)
    }

    private func updateLinks(trolleys: [Trolley]) {
        let routes = routeService.currentActiveRoutes
        links = TrolleyRouteLink.link(trolleys: trolleys, to: routes)
    }
}