//
//  TrolleyRouteLink.swift
//  TrolleyTracker
//
//  Created by Austin on 8/19/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

/// Associates a TrolleyRoute with Trolleys assigned to that route.
struct TrolleyRouteLink {

    let trolleys: [Trolley]
    let route: TrolleyRoute
}
