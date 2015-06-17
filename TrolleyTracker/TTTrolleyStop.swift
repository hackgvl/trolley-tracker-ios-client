//
//  TTTrolleyStop.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TTTrolleyStop: NSObject, Equatable {
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
    
    let name: String
    let location: CLLocation
}

func ==(lhs: TTTrolleyStop, rhs: TTTrolleyStop) -> Bool {
    return lhs.name == rhs.name
}