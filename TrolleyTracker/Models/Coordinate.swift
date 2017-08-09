//
//  Coordinate.swift
//  TrolleyTracker
//
//  Created by Austin on 8/7/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

struct Coordinate: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees

    init(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.latitude = latitude
        self.longitude = longitude
    }

    init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }

    init(location: CLLocation) {
        self.init(coordinate: location.coordinate)
    }

    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
