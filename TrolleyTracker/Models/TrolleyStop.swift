//
//  TrolleyStop.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit



/// Represents a point where the Trolleys stop for passengers.
class TrolleyStop: NSObject {
    
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
        
        self.stopDescription = json["Description"].stringValue
        self.location = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
        self.stopID = json["ID"].intValue
        self.name = json["Name"].stringValue
        
        super.init()
        
        let ID = json["ID"].int
        if ID == nil { return nil }
    }
    
    convenience init?(jsonData: AnyObject, colorIndex: Int) {
        self.init(json: JSON(jsonData))
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? TrolleyStop , object.stopID == self.stopID { return true }
        return false
    }
}

extension TrolleyStop: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String? {
        return name
    }
    
    var subtitle: String? {
        return ""
    }
}
