//
//  User.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/12/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

struct User {
    
    static var currentLocation: CLLocation? {
        get {
            return CLLocation(latitude: 22, longitude: 22)
        }
    }
    
}