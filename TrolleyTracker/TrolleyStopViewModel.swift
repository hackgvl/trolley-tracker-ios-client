//
//  TrolleyStopViewModel.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/11/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

enum TransportationType {
    case Trolley
    case Walking
}

class TrolleyStopViewModel {
    
    let name: String
    let location: CLLocation
    var walkingTime: String = "-----"
    var trolleyTime: String = "-----"
    
    init(name: String, location: CLLocation) {
        
        self.name = name
        self.location = location
    }
    
    init() {
        let stop = TrolleyStopViewModel.randomStop()
        self.name = stop.name
        self.location = stop.location
    }
    
    func updateWalkingTime(completion: () -> ()) {
        
        getETA(TransportationType.Walking, completion: { eta in
            self.walkingTime = self.displayTime(eta)
            completion()
        })
    }
    
    func updateTrolleyTime(completion: () -> ()) {
        
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil))
        getETA(TransportationType.Trolley, completion: { eta in
            self.trolleyTime = self.displayTime(eta)
            completion()
        })
    }
    
    func getETA(transportationType: TransportationType, completion: (eta: NSTimeInterval) -> ()) {
        
        let request = MKDirectionsRequest()
        request.setSource(MKMapItem.mapItemForCurrentLocation())
        request.setDestination(MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)))
        
        switch transportationType {
        case .Walking:
            request.transportType = MKDirectionsTransportType.Walking
        case .Trolley:
            request.transportType = MKDirectionsTransportType.Automobile
        }
        
        let directions = MKDirections(request: request)
        directions.calculateETAWithCompletionHandler { (response: MKETAResponse!, error: NSError!) -> Void in
            if (response != nil) {
                completion(eta: response.expectedTravelTime)
                println("ETA Response: \(response.expectedTravelTime)")
            }
            else {
                println("Error: \(error)")
            }
        }
        println("Getting ETA: \(directions)")
    }
    
    func displayTime(timeInterval: NSTimeInterval) -> String {
        let minutes = Int(timeInterval / 60)
        let seconds = Int(timeInterval % 60)
        return "\(minutes):\(seconds)"
    }
    
    
    
    class func randomStop() -> (name: String, location: CLLocation!) {
        
        let stops = [
            (name: "Richardson St @ Washington St", location: CLLocation(latitude: 34.851289, longitude: -82.400666)),
            (name: "Richardson St @ Court St", location: CLLocation(latitude: 34.849260, longitude: -82.402082)),
            (name: "Richardson St @ E North St", location: CLLocation(latitude: 34.853006, longitude:  -82.399925))
        ]
        
        return stops[Int(arc4random_uniform(UInt32(stops.count)))]
    }
    
}