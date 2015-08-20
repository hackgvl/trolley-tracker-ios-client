//
//  TrolleyStop.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation


/// Represents a point where the Trolleys stop for passengers.
class TrolleyStop: NSObject, Equatable {
    
    let stopID: Int
    let name: String
    let stopDescription: String
    let location: CLLocation
    
    init(name: String, location: CLLocation, description: String, ID: Int) {
        self.name = name
        self.location = location
        self.stopDescription = description
        self.stopID = ID
    }
    
    init?(json: JSON) {
        
        let lat = json["Lat"].stringValue
        let lon = json["Lon"].stringValue
        
        self.name = json["Name"].stringValue
        self.stopDescription = json["Description"].stringValue
        self.location = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
        self.stopID = json["ID"].intValue
        
        super.init()
        
        let ID = json["ID"].int
        if ID == nil { return nil }
    }
    
    convenience init?(jsonData: AnyObject) {
        self.init(json: JSON(jsonData))
    }
}

func ==(lhs: TrolleyStop, rhs: TrolleyStop) -> Bool {
    return lhs.stopID == rhs.stopID
}