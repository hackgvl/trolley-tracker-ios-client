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
        
        TrolleyRequests.Stops.responseJSON { (request, response, json, error) -> Void in
            
            completion(stops: self.parseStopsFromJSON(json))
        }
    }
    
    private func parseStopsFromJSON(json: AnyObject?) -> [TTTrolleyStop] {
        
        var stops = [TTTrolleyStop]()
        
        if let json: AnyObject = json,
        stopObjects = JSON(json).arrayObject
        {
            stops = stopObjects.map { TTTrolleyStop(jsonData: $0) }.filter { $0 != nil }.map {$0!}
        }
        
        return stops
    }
}