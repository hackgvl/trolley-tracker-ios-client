//
//  DetailController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class DetailController: FunctionController {

    typealias Dependencies = HasModelController

    private let viewController: DetailViewController

    private var currentUserLocation: MKUserLocation?
    private var currentAnnotation: MKAnnotation?

    init(dependencies: Dependencies) {
        self.viewController = DetailViewController()
    }

    func prepare() -> UIViewController {
        viewController.delegate = self
        return viewController
    }

    func show(annotation: MKAnnotation?, userLocation: MKUserLocation?) {

        currentUserLocation = userLocation
        currentAnnotation = annotation

        if let trolley = annotation as? Trolley {
            viewController.show(titleText: trolley.name ?? "")
        }
        else if let stop = annotation as? TrolleyStop {
            viewController.show(titleText: stop.name)
        }
        else {
            viewController.resetUI()
            return
        }

        showDistance()
        getWalkingTime(true)
    }

    private func showDistance() {
        guard let c1 = currentUserLocation?.coordinate,
            let c2 = currentAnnotation?.coordinate else {
                return
        }
        let string = MKDistanceFormatter.standard.string(fromDistance: c1.distance(from: c2))
        viewController.show(distance: string)
    }

    private func getDirections(_ pointB: CLLocationCoordinate2D) {
        //TODO: Make this the name of the stop or Trolley
        let name = "Trolley"
        MKMapItem.openMapsFromCurrentLocation(toCoordinate: pointB, named: name)
    }

    private func getWalkingTime(_ cacheResultsOnly: Bool) {

        guard let annotation = currentAnnotation else { return }
        guard let userLocation = currentUserLocation?.location else { return }

        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate,
                                          addressDictionary: nil)
        let source = MKMapItem(placemark: sourcePlacemark)

        let destinationPlacemark = MKPlacemark(coordinate: annotation.coordinate,
                                               addressDictionary: nil)
        let destination = MKMapItem(placemark: destinationPlacemark)

        viewController.showWalkingLoadingUI()

        TimeAndDistanceService.walkingTravelTimeBetween(pointA: source,
                                                        pointB: destination,
                                                        cacheResultsOnly: cacheResultsOnly,
                                                        completion: handleWalkingTimeResult(_:_:))
    }

    private func handleWalkingTimeResult(_ rawTime: TimeInterval?,
                                         _ formattedTime: String?) {
        guard let formattedTime = formattedTime else {
            viewController.show(walkingTime: "")
            return
        }
        viewController.show(walkingTime: formattedTime)
    }
}

extension DetailController: DetailViewControllerDelegate {

    func directionsButtonTapped() {

        guard let location = currentAnnotation?.directionLocation else {
            return
        }

        getDirections(location.coordinate)
    }

    func walkingTimeButtonTapped() {
        getWalkingTime(false)
    }
}

private extension MKAnnotation {

    var directionLocation: CLLocation? {
        if let trolley = self as? Trolley {
            return CLLocation(latitude: trolley.coordinate.latitude,
                              longitude: trolley.coordinate.longitude)
        }
        if let stop = self as? TrolleyStop {
            return stop.location
        }
        return nil
    }
}
