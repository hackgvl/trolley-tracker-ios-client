//
//  MapViewHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 3/22/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import MapKit

extension MKMapView {

    var trolleyAnnotations: [Trolley] {
        return annotations.flatMap { $0 as? Trolley }
    }

    func centerOnUserPossible(presentationContext: UIViewController) {

        let userCoordinate = userLocation.coordinate
        if userCoordinate.latitude != 0 && userCoordinate.longitude != 0 {
            setCenter(userCoordinate, animated: true)
        }
        else {
            let controller = AlertController(title: nil, message: "We're sorry, we can't find your current location right now.", preferredStyle: UIAlertControllerStyle.alert)
            controller.tintColor = UIColor.ttAlternateTintColor()
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            presentationContext.present(controller, animated: true, completion: nil)
        }
    }

    func replaceCurrentRoutes(with routes: [TrolleyRoute]) {

        // FIXME: Remove current routes

        // For each route,
        for var route in routes {

            // -- Add overlays
            add(route.overlay)

            // -- Add stops
            for stop in route.stops {
                addAnnotation(stop)
            }
        }
    }

    func addOrUpdateTrolley(_ trolley: Trolley) {

        // Get our Trolley Annotations
        let existing = trolleyAnnotations

        // If we're already showing this Trolly, just update it
        if let index = existing.index(of: trolley) {
            let existingAnnotation = existing[index]
            existingAnnotation.coordinate = trolley.location.coordinate
        }
            // Otherwise, add it
        else {
            addAnnotation(trolley)
        }
    }

    func setRegionToDowntownGreenville() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(34.851887, -82.398366), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    }
}
