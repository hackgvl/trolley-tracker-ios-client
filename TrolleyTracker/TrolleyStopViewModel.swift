//
//  TrolleyStopViewModel.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/11/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

enum TransportationType {
    case Trolley
    case Walking
}

struct TrolleyStopViewModel {
    
    let name: String
    
    init() {
        
        self.name = TrolleyStopViewModel.randomStopName()
    }
    
    func travelTimeFromLocation(location: CLLocation, transportationType: TransportationType) -> String {
        
        switch transportationType {

        case .Trolley:
            return "4:33"
            
        case .Walking:
            return "7 min"
        }
    }
    
    static func randomStopName() -> String {
        
        let names = [
            "Richardson St @ Washington St",
        "Richardson St @ Court St",
        "Richardosn St @ E North St"
        ]
        
        return names[Int(arc4random_uniform(UInt32(names.count)))]
    }
    
}