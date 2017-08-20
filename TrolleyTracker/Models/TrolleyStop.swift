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
class TrolleyStop: NSObject, Codable {
    
    let stopID: Int
    let name: String
    let stopDescription: String
    let lastTrolleyArrivals: [Int: String]
    private let colorIndex: Int

    private let _coordinate: Coordinate

    var location: CLLocation {
        return _coordinate.location
    }

    var color: UIColor {
        return .stopColorForIndex(colorIndex)
    }
    
    init(name: String,
         latitude: Double,
         longitude: Double,
         description: String,
         ID: Int,
         lastTrolleyArrivals: [Int: String],
         colorIndex: Int) {
        self.name = name
        self._coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.stopDescription = description
        self.stopID = ID
        self.lastTrolleyArrivals = lastTrolleyArrivals
        self.colorIndex = colorIndex
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
