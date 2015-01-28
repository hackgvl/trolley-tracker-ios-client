//
//  NetworkController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/20/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

protocol NetworkControllerDelegate: class {
    
    func controller(_: NetworkController, didUpdateTrolley trolley: Trolley, withLocation location: CLLocation)
}

class NetworkController {
    
    var trolleysBeingTracked = [Trolley]()
    weak var delegate: NetworkControllerDelegate?
    
    init() {

    }
    
    internal func downloadTrolleyList(completion: ([Trolley]) -> ()) {
        
        //////////// Simulation data ///////////////////////
        let trolley1 = Trolley(name: "Trolley 1")
        let trolley2 = Trolley(name: "Trolley 2")
        let trolleyModels = [trolley1, trolley2]
        //////////// Simulation data ///////////////////////
        
        completion(trolleyModels)
    }
    
    internal func startTrackingTrolley(trolley: Trolley) {
        trolleysBeingTracked.append(trolley)
        updateTracking()
    }
    
    internal func stopTrackingTrolley(trolley: Trolley) {
        if let index = find(trolleysBeingTracked, trolley) {
            trolleysBeingTracked.removeAtIndex(index)
            updateTracking()
        }
    }
    
    private func updateTracking() {
        
    }
}
