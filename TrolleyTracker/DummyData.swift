//
//  DummyData.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/20/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

struct DummyData {
    
    static let route1 = DummyData.reorderArray(DummyData.masterRoute, startingIndex: 0)
    static let route2 = DummyData.reorderArray(DummyData.masterRoute, startingIndex: 6)
    
    static func reorderArray<T>(array: [T], startingIndex: Int) -> [T] {
        
        var newArray: [T] = []
        
        for i in startingIndex..<(array.count + startingIndex) {
            if i < array.count { newArray.append(array[i]) }
            else { newArray.append(newArray[i - array.count]) }
        }
        
        return newArray
    }
    
    static let masterRoute = [
        TrolleyRoutePoint(location: CLLocation(latitude: 34.846605, longitude: -82.404312), name: "Camperdown and River"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.846112, longitude: -82.402917), name: "Camperdown and Rhett"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.846112, longitude: -82.402917), name: "Camperdown and Main"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.846138, longitude: -82.401200), name: "Main and Murphy"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.847609, longitude: -82.400428), name: "Main and E Broad"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.848507, longitude: -82.400015), name: "Main and Court"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.849660, longitude: -82.399468), name: "Main and McBee"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.850726, longitude: -82.398969), name: "Main and Washington"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.851276, longitude: -82.400677), name: "Washington and Richardson"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.850281, longitude: -82.401471), name: "Richardson and McBee"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.849189, longitude: -82.402050), name: "River and Court"),
        TrolleyRoutePoint(location: CLLocation(latitude: 34.848635, longitude: -82.402705), name: "River and Broad"),
    ]
    
}