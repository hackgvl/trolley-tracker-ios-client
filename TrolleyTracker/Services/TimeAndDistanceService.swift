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
    let resultRaw: TimeInterval
    let resultFormatted: String
}

class TimeAndDistanceService {
    
    fileprivate static var etaCache = [ETAResult]()
    
    typealias TravelTimeCompletion = (_ rawTime: TimeInterval?, _ formattedTime: String?) -> Void
    
    fileprivate static var etaRequestQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
        }()
    
    static func walkingTravelTimeBetween(pointA: MKMapItem,
                                         pointB: MKMapItem,
                                         cacheResultsOnly: Bool,
                                         completion: @escaping TravelTimeCompletion) {
        
        for cacheResult in TimeAndDistanceService.etaCache {
            
            let failure = { completion(nil, nil) }
            
            guard let newPointALocation = pointA.placemark.location else { failure(); return }
            guard let newPointBLocation = pointB.placemark.location else { failure(); return }
            guard let cachedPointALocation = cacheResult.pointA.placemark.location else { failure(); return }
            guard let cachedPointBLocation = cacheResult.pointB.placemark.location else { failure(); return }
            
            let pointADistance = newPointALocation.distance(from: cachedPointALocation)
            let pointBDistance = newPointBLocation.distance(from: cachedPointBLocation)
            
            var shouldUseCacheResult = true
            if pointADistance > 100 { shouldUseCacheResult = false }
            if pointBDistance > 50 { shouldUseCacheResult = false }
            
            if shouldUseCacheResult {
                DispatchQueue.main.async {
                    completion(cacheResult.resultRaw, cacheResult.resultFormatted)
                }
                return
            }
        }
        
        if cacheResultsOnly {
            DispatchQueue.main.async {
                completion(nil, nil)
            }
            return
        }
        
        let operation = GetETAOperation(source: pointA, destination: pointB)
        operation.completionBlock = { [unowned operation] in
            
            if let rawTime = operation.expectedTravelTime,
                let formattedTime = operation.formattedTravelTime {
                let result = ETAResult(pointA: pointA,
                                       pointB: pointB,
                                       resultRaw: rawTime,
                                       resultFormatted: formattedTime)
                TimeAndDistanceService.etaCache.append(result)

                DispatchQueue.main.async {
                    completion(rawTime, formattedTime)
                }
            }
        }
        
        etaRequestQueue.cancelAllOperations()
        etaRequestQueue.addOperation(operation)
    }
}


