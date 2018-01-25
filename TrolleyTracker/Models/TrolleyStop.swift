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
    let nextTrolleyArrivals: [TrolleyArrivalTime]
    let color: UIColor

    private let _coordinate: Coordinate

    var location: CLLocation {
        return _coordinate.location
    }
    
    init(name: String,
         latitude: Double,
         longitude: Double,
         description: String,
         ID: Int,
         lastTrolleyArrivals: [Int: String],
         color: UIColor) {
        self.name = name
        self._coordinate = Coordinate(latitude: latitude, longitude: longitude)
        self.stopDescription = description
        self.stopID = ID
        self.nextTrolleyArrivals = TrolleyArrivalTime.from(lastTrolleyArrivals)
        self.color = color
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

struct TrolleyArrivalTime {
    let trolleyID: Int
    let date: Date

    private static var formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return df
    }()

    static func from(_ values: [Int : String]) -> [TrolleyArrivalTime] {
        return values.flatMap {
            let string = Array($0.1.components(separatedBy: ".")).dropLast().joined()
            guard let date = TrolleyArrivalTime.formatter.date(from: string) else {
                return nil
            }
            return TrolleyArrivalTime(trolleyID: $0.key, date: date)
        }
    }
}
