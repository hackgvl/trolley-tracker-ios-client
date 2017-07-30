//
//  ApplicationController.swift
//  TrolleyTracker
//
//  Created by Austin on 3/22/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class ApplicationController {

    let client: APIClient
    let trolleyRouteService: TrolleyRouteService
    let trolleyLocationService: TrolleyLocationService
    let trolleyScheduleService: TrolleyScheduleService

    init() {

        let c = APIClient(session: URLSession.shared)
        self.client = c

        trolleyScheduleService = TrolleyScheduleService(client: client)

        trolleyLocationService = TrolleyLocationServiceLive(client: client)
        trolleyRouteService = TrolleyRouteServiceLive(client: client)
    }
}
