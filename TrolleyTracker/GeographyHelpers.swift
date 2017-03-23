//
//  GeographyHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 3/23/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import MapKit

extension CLLocationCoordinate2D {

    func distance(from otherCoordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let pointA = CLLocation(latitude: latitude,
                                longitude: longitude)
        let pointB = CLLocation(latitude: otherCoordinate.latitude,
                                longitude: otherCoordinate.longitude)
        return pointA.distance(from: pointB)
    }
}

extension MKMapItem {

    static func openMapsFromCurrentLocation(toCoordinate coordinate: CLLocationCoordinate2D,
                                            named name: String) {

        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let currentLocation = MKMapItem.forCurrentLocation()
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let mapItem = MKMapItem(placemark: placeMark)

        mapItem.name = name

        MKMapItem.openMaps(with: [currentLocation, mapItem], launchOptions: launchOptions)
    }
}
