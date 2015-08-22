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
class TrolleyStop: NSObject, Equatable {
    
    let stopID: Int
    let name: String
    let stopDescription: String
    let location: CLLocation
    let colorIndex: Int
    
    init(name: String, location: CLLocation, description: String, ID: Int, colorIndex: Int) {
        self.name = name
        self.location = location
        self.stopDescription = description
        self.stopID = ID
        self.colorIndex = colorIndex
    }
    
    init?(json: JSON, colorIndex: Int) {
        
        let lat = json["Lat"].stringValue
        let lon = json["Lon"].stringValue
        
        self.name = json["Name"].stringValue
        self.stopDescription = json["Description"].stringValue
        self.location = CLLocation(latitude: (lat as NSString).doubleValue, longitude: (lon as NSString).doubleValue)
        self.stopID = json["ID"].intValue
        self.colorIndex = colorIndex
        
        super.init()
        
        let ID = json["ID"].int
        if ID == nil { return nil }
    }
    
    convenience init?(jsonData: AnyObject, colorIndex: Int) {
        self.init(json: JSON(jsonData), colorIndex: colorIndex)
    }
}

extension TrolleyStop: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String! {
        // TODO: Return Trolley Name
        return name
    }
    
    var subTitle: String! {
        return ""
    }
}

func ==(lhs: TrolleyStop, rhs: TrolleyStop) -> Bool {
    return lhs.stopID == rhs.stopID
}