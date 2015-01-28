//
//  TrolleyViewModel.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/11/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TrolleyViewModel {
    
    let model: Trolley
    var currentLocation: CLLocation?
    var upcomingStops: [TrolleyStopViewModel]
    var name: String
    
    init(trolley: Trolley) {
        self.model = trolley
        self.name = trolley.name
        self.upcomingStops = []
        
        //////////////// Dummy data /////////////////////////
        for _ in 0..<3 {
            self.upcomingStops.append(TrolleyStopViewModel())
        }
        /////////////////////////////////////////////////////
    }
 
}