//
//  MKMapView+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 2/21/16.
//  Copyright © 2016 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

extension MKMapView {
    
    func setRegionToDowntownGreenville() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(34.851887, -82.398366), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
}
