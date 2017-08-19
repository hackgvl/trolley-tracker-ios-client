//
//  TrolleyServiceProtocols.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

typealias LoadTrolleyRouteCompletion = (_ routes: [TrolleyRoute]) -> Void

protocol TrolleyRouteService {
    
    func loadTrolleyRoute(_ routeID: Int, completion: @escaping  LoadTrolleyRouteCompletion)
    func loadTrolleyRoutes(_ completion: @escaping LoadTrolleyRouteCompletion)
}

protocol TrolleyLocationService {
    
    var trolleyObservers: ObserverSet<[Trolley]> { get }

    func startTrackingTrolleys()
    func stopTrackingTrolley()
}
