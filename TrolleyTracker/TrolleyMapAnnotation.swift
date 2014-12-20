//
//  TrolleyMapAnnotation.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/14/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit


class TrolleyMapAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}