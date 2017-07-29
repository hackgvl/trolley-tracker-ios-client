//
//  GetETAOperation.swift
//  
//
//  Created by Austin Younts on 8/23/15.
//
//

import Foundation
import MapKit


class GetETAOperation: ConcurrentOperation {
    
    fileprivate static let travelTimeDateFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        
        return formatter
        }()
    
    var expectedTravelTime: TimeInterval?
    var formattedTravelTime: String?
    
    fileprivate let source: MKMapItem
    fileprivate let destination: MKMapItem
    
    init(source: MKMapItem, destination: MKMapItem) {
        self.source = source
        self.destination = destination
    }
    
    override func execute() {
        
        if isCancelled {
            self.finish()
            return
        }
        
        let request = MKDirectionsRequest()
        request.source = source
        request.destination = destination
        request.transportType = MKDirectionsTransportType.walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateETA { (response, error) -> Void in
            
            guard let response = response else { self.finish(); return }
            
            let time = response.expectedTravelTime
            var travelTimeComponents = DateComponents()
            travelTimeComponents.hour = Int(floor(time / 3600))
            travelTimeComponents.minute = Int(ceil((time.truncatingRemainder(dividingBy: 3600)) / 60))
            
            let componentsString = GetETAOperation.travelTimeDateFormatter.string(from: travelTimeComponents)
            
            self.expectedTravelTime = response.expectedTravelTime
            self.formattedTravelTime = componentsString
            
            self.finish()
        }
    }
}

