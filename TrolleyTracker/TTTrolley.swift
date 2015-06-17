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
    
    init?(jsonData: AnyObject) {
        
        let json = JSON(jsonData)
        
        let name = json["name"].stringValue
        let lat = json["where"]["lat"].stringValue
        let lon = json["where"]["lon"].stringValue
        let identifier = json["who"].numberValue.stringValue
        
        self.location = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
        self.identifier = identifier
        self.name = name
    }
    
    let name: String
    let identifier: String
    let location: CLLocation
}