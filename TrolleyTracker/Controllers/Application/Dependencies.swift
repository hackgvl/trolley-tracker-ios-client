//
//  Dependencies.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

protocol HasRouteService {
    var routeService: TrolleyRouteService { get }
}
protocol HasLocationService {
    var locationService: TrolleyLocationService { get }
}
protocol HasScheduleService {
    var scheduleService: TrolleyScheduleService { get }
}

struct AppDependencies:
    HasRouteService,
    HasLocationService,
HasScheduleService {

    let routeService: TrolleyRouteService
    let locationService: TrolleyLocationService
    let scheduleService: TrolleyScheduleService

    init(client: APIClient) {
        scheduleService = TrolleyScheduleService(client: client)
        locationService = TrolleyLocationServiceLive(client: client)
        routeService = TrolleyRouteServiceLive(client: client)
    }
}
