//
//  ApplicationController.swift
//  TrolleyTracker
//
//  Created by Austin on 3/22/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class ApplicationController {

    let trolleyRouteService: TrolleyRouteService
    let trolleyLocationService: TrolleyLocationService
    let trolleyScheduleService: TrolleyScheduleService

    init() {

        trolleyScheduleService = TrolleyScheduleService()

        trolleyLocationService = TrolleyLocationServiceLive.sharedService
        trolleyRouteService = TrolleyRouteServiceLive()

//        switch EnvironmentVariables.currentBuildConfiguration() {
//        case .Release:
//            trolleyLocationService = TrolleyLocationServiceLive.sharedService
//            trolleyRouteService = TrolleyRouteServiceLive()
//        case .Test:
//            trolleyLocationService = TrolleyLocationServiceFake()
//            trolleyRouteService = TrolleyRouteServiceFake()
//        }
    }
}
