//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TTTrolleyStopService {
    
    typealias LoadTrolleyStopCompletion = (stops: [TTTrolleyStop]) -> Void
 
    static var sharedService = TTTrolleyStopService()
    
    func loadTrolleyStops(completion: LoadTrolleyStopCompletion) {
        
        // Call "/Stops" to get the list of stops
        
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), {
//            completion(stops: self.dummyTrolleyStops)
        })
    }
    
    
    
//    var dummyTrolleyStops = [
//    
//        TTTrolleyStop(name: "Camperdown and River", location: CLLocation(latitude: 34.846605, longitude: -82.404312)),
//        TTTrolleyStop(name: "Camperdown and Rhett", location: CLLocation(latitude: 34.846112, longitude: -82.402917)),
//        TTTrolleyStop(name: "Camperdown and Main", location: CLLocation(latitude: 34.846112, longitude: -82.402917)),
//        TTTrolleyStop(name: "Main and Murphy", location: CLLocation(latitude: 34.846138, longitude: -82.401200)),
//        TTTrolleyStop(name: "Main and E Broad", location: CLLocation(latitude: 34.847609, longitude: -82.400428)),
//        TTTrolleyStop(name: "Main and Court", location: CLLocation(latitude: 34.848507, longitude: -82.400015)),
//        TTTrolleyStop(name: "Main and McBee", location: CLLocation(latitude: 34.849660, longitude: -82.399468)),
//        TTTrolleyStop(name: "Main and Washington", location: CLLocation(latitude: 34.850726, longitude: -82.398969)),
//        TTTrolleyStop(name: "Washington and Richardson", location: CLLocation(latitude: 34.851276, longitude: -82.400677)),
//        TTTrolleyStop(name: "Richardson and McBee", location: CLLocation(latitude: 34.850281, longitude: -82.401471)),
//        TTTrolleyStop(name: "River and Court", location: CLLocation(latitude: 34.849189, longitude: -82.402050)),
//        TTTrolleyStop(name: "River and Broad", location: CLLocation(latitude: 34.848635, longitude: -82.402705)),
//    
//    ]
}