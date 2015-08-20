//
//  TrolleyRoute.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/19/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation


func ==(lhs: TrolleyRoute, rhs: TrolleyRoute) -> Bool {
    return lhs.ID == rhs.ID
}


/// Represents a route that trolleys follow. 
struct TrolleyRoute {
    
    let ID: Int
    let shortName: String
    let longName: String
    let routeDescription: String
    let flagStopsOnly: Bool
    
    let stops: [TrolleyStop]
    let shapePoints: [CLLocation]
    
    init?(json: JSON) {
        
        self.ID = json["ID"].intValue
        self.shortName = json["ShortName"].stringValue
        self.longName = json["LongName"].stringValue
        self.routeDescription = json["Description"].stringValue
        self.flagStopsOnly = json["FlagStopsOnly"].boolValue
        
        self.stops = json["Stops"].arrayValue.map { TrolleyStop(json: $0) }.filter { $0 != nil }.map { $0! }

        var points = [CLLocation]()
        var jsonPoints = json["RouteShape"].arrayValue

        for point in jsonPoints {
            let lat = point["Lat"].doubleValue
            let lon = point["Lon"].doubleValue
            points.append(CLLocation(latitude: lat, longitude: lon))
        }
        
        self.shapePoints = points 
    }
}


