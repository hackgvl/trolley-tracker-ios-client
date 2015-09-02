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
    
    private static let travelTimeDateFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.unitsStyle = .Abbreviated
        
        return formatter
        }()
    
    var expectedTravelTime: NSTimeInterval?
    var formattedTravelTime: String?
    
    private let source: MKMapItem
    private let destination: MKMapItem
    
    init(source: MKMapItem, destination: MKMapItem) {
        self.source = source
        self.destination = destination
    }
    
    override func execute() {
        
        if cancelled {
            self.finish()
            return
        }
        
        let request = MKDirectionsRequest()
        request.source = source
        request.destination = destination
        request.transportType = MKDirectionsTransportType.Walking
        
        let directions = MKDirections(request: request)
        
        directions.calculateETAWithCompletionHandler { (response, error) -> Void in
            
            guard let response = response else { self.finish(); return }
            
            let time = response.expectedTravelTime
            let travelTimeComponents = NSDateComponents()
            travelTimeComponents.hour = Int(floor(time / 3600))
            travelTimeComponents.minute = Int(ceil((time % 3600) / 60))
            
            let componentsString = GetETAOperation.travelTimeDateFormatter.stringFromDateComponents(travelTimeComponents)
            
            self.expectedTravelTime = response.expectedTravelTime
            self.formattedTravelTime = componentsString
            
            self.finish()
        }
    }
}

