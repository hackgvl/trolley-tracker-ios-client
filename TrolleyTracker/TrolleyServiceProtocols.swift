//
//  TrolleyServiceProtocols.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

typealias LoadTrolleyRouteCompletion = (routes: [TrolleyRoute]) -> Void

protocol TrolleyRouteService {
    
    func loadTrolleyRoutes(completion: LoadTrolleyRouteCompletion)
}

protocol TrolleyLocationService {
    
    var trolleyObservers: ObserverSet<Trolley> { get }
    var trolleyPresentObservers: ObserverSet<Bool> { get }
    
    func startTrackingTrolleys()
    func stopTrackingTrolley()
}