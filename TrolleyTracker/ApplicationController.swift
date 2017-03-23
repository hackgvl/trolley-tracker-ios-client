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

    init() {

        switch EnvironmentVariables.currentBuildConfiguration() {
        case .Release:
            trolleyLocationService = TrolleyLocationServiceLive.sharedService
            trolleyRouteService = TrolleyRouteServiceLive.sharedService
        case .Test:
            trolleyLocationService = TrolleyLocationServiceFake()
            trolleyRouteService = TrolleyRouteServiceFake()
        }
    }
}
