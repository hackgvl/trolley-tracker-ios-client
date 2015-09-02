//
//  TimeAndDistanceService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/23/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

private struct ETAResult {
    let pointA: MKMapItem
    let pointB: MKMapItem
    let resultRaw: NSTimeInterval
    let resultFormatted: String
}

class TimeAndDistanceService {
    
    private static var etaCache = [ETAResult]()
    
    typealias TravelTimeCompletion = (rawTime: NSTimeInterval?, formattedTime: String?) -> Void
    
    private static var etaRequestQueue: NSOperationQueue = {
        let queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    static func walkingTravelTimeBetweenPoints(pointA: MKMapItem, pointB: MKMapItem, cacheResultsOnly: Bool, completion: TravelTimeCompletion) {
        
        for cacheResult in TimeAndDistanceService.etaCache {
            
            let failure = { completion(rawTime: nil, formattedTime: nil) }
            
            guard let newPointALocation = pointA.placemark.location else { failure(); return }
            guard let newPointBLocation = pointB.placemark.location else { failure(); return }
            guard let cachedPointALocation = cacheResult.pointA.placemark.location else { failure(); return }
            guard let cachedPointBLocation = cacheResult.pointB.placemark.location else { failure(); return }
            
            let pointADistance = newPointALocation.distanceFromLocation(cachedPointALocation)
            let pointBDistance = newPointBLocation.distanceFromLocation(cachedPointBLocation)
            
            var shouldUseCacheResult = true
            if pointADistance > 100 { shouldUseCacheResult = false }
            if pointBDistance > 50 { shouldUseCacheResult = false }
            
            if shouldUseCacheResult {
                completion(rawTime: cacheResult.resultRaw, formattedTime: cacheResult.resultFormatted)
                return
            }
        }
        
        if cacheResultsOnly {
            completion(rawTime: nil, formattedTime: nil)
            return
        }
        
        let operation = GetETAOperation(source: pointA, destination: pointB)
        operation.completionBlock = { [unowned operation] in
            
            if let rawTime = operation.expectedTravelTime, formattedTime = operation.formattedTravelTime {
                TimeAndDistanceService.etaCache.append(ETAResult(pointA: pointA, pointB: pointB, resultRaw: rawTime, resultFormatted: formattedTime))
            }
            
            completion(rawTime: operation.expectedTravelTime, formattedTime: operation.formattedTravelTime)
        }
        
        etaRequestQueue.cancelAllOperations()
        etaRequestQueue.addOperation(operation)
    }
}


