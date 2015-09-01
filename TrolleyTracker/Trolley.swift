//
//  Trolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit

class Trolley: NSObject, Equatable {
    
    let ID: Int
    var location: CLLocation
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
        
        var currentLat = json["CurrentLat"].float
        var latitude: String? = currentLat != nil ? String(format: "%.7f", currentLat!) : nil
        if latitude == nil { latitude = json["Lat"].stringValue }
        
        var currentLon = json["CurrentLon"].float
        var longitude: String? = currentLon != nil ? String(format: "%.7f", currentLon!) : nil
        if longitude == nil { longitude = json["Lon"].stringValue }
        
        self.ID = json["ID"].intValue
        self.location = CLLocation(latitude: (latitude! as NSString).doubleValue, longitude: (longitude! as NSString).doubleValue)
        
        self.number = json["Number"].int
        self.name = json["TrolleyName"].stringValue + " - " + "\(self.ID)"
    }
    
    init(trolley: Trolley, location: CLLocation) {
        
        self.ID = trolley.ID
        self.location = location
        self.name = trolley.name
        self.number = trolley.number
    }
}

extension Trolley: MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
        }
        set(newValue) {
            self.willChangeValueForKey("coordinate")
            location = CLLocation(latitude: newValue.latitude, longitude: newValue.longitude)
            self.didChangeValueForKey("coordinate")
        }
    }
    
    var title: String! {
        return name
    }
    
    var subTitle: String! {
        return ""
    }
}

func ==(lhs: Trolley, rhs: Trolley) -> Bool {
    return lhs.ID == rhs.ID
}