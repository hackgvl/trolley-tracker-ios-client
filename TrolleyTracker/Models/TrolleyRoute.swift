//
//  TrolleyRoute.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/19/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit



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
    let color: UIColor
    
    let stops: [TrolleyStop]
    let shapePoints: [CLLocation]
    
    lazy var overlay: MKOverlay = {
        
        let coordinates = self.shapePoints.map { $0.coordinate }
        let coordinatesPointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: coordinates)
        let polyline = TrolleyRouteOverlay(coordinates: coordinatesPointer, count: coordinates.count)
        polyline.color = self.color

        return polyline
    }()
    
    init?(json: JSON, colorIndex: Int) {

        let sn = json["ShortName"].stringValue
        self.ID = json["ID"].intValue
        self.shortName = sn
        self.longName = json["LongName"].stringValue
        self.routeDescription = json["Description"].stringValue
        self.flagStopsOnly = json["FlagStopsOnly"].boolValue
        self.color = GreenlinkColor(routeName: sn)?.color ?? .black
        
        self.stops = json["Stops"].arrayValue.map { TrolleyStop(json: $0) }.filter { $0 != nil }.map { $0! }

        var points = [CLLocation]()
        let jsonPoints = json["RouteShape"].arrayValue

        for point in jsonPoints {
            let lat = point["Lat"].doubleValue
            let lon = point["Lon"].doubleValue
            points.append(CLLocation(latitude: lat, longitude: lon))
        }
        
        self.shapePoints = points 
    }
}


