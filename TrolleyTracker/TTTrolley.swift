//
//  TTTrolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TTTrolley: NSObject {
    
    init(name: String, identifier: String, location: CLLocation) {
        self.name = name
        self.identifier = identifier
        self.location = location
    }
    
    let name: String
    let identifier: String
    let location: CLLocation
}