//
//  TTTrolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TTTrolley: NSObject, Equatable {
    
    let ID: Int
    let location: CLLocation
    let name: String?
    let number: Int?
    
    init(identifier: Int, location: CLLocation, name: String?, number: Int?) {
        self.name = name
        self.ID = identifier
        self.location = location
        self.number = number
    }
    
    init?(jsonData: AnyObject) {
        
        let json = JSON(jsonData)
        
        var latitude = json["CurrentLat"].string
        if latitude == nil { latitude = json["Lat"].stringValue }
        
        var longitude = json["CurrentLon"].string
        if longitude == nil { longitude = json["Lon"].stringValue }
        
        self.ID = json["ID"].intValue
        self.location = CLLocation(latitude: (latitude! as NSString).doubleValue, longitude: (longitude! as NSString).doubleValue)
        
        self.name = json["TrolleyName"].string
        self.number = json["Number"].int
    }
    
    init(trolley: TTTrolley, location: CLLocation) {
        
        self.ID = trolley.ID
        self.location = location
        self.name = trolley.name
        self.number = trolley.number
    }
}

func ==(lhs: TTTrolley, rhs: TTTrolley) -> Bool {
    return lhs.ID == rhs.ID
}