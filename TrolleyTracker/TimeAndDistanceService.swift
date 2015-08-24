//
//  TimeAndDistanceService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/23/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class TimeAndDistanceService {
    
    typealias TravelTimeCompletion = (rawTime: NSTimeInterval?, formattedTime: String?) -> Void
    
    private static var etaRequestQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    static func walkingTravelTimeBetweenPoints(pointA: MKMapItem, pointB: MKMapItem, completion: TravelTimeCompletion) {
        
        var operation = GetETAOperation(source: pointA, destination: pointB)
        operation.completionBlock = { [unowned operation] in
            completion(rawTime: operation.expectedTravelTime, formattedTime: operation.formattedTravelTime)
        }
        
        etaRequestQueue.cancelAllOperations()
        etaRequestQueue.addOperation(operation)
    }
}


