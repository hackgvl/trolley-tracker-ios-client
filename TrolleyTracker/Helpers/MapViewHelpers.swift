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

    var trolleyStopAnnotations: [TrolleyStop] {
        return annotations.flatMap { $0 as? TrolleyStop }
    }

    var trolleyRouteOverlays: [TrolleyRouteOverlay] {
        return overlays.flatMap { $0 as? TrolleyRouteOverlay }
    }

    func centerOnUser(context: UIViewController) {

        let userCoordinate = userLocation.coordinate
        if userCoordinate.latitude != 0 && userCoordinate.longitude != 0 {
            setCenter(userCoordinate, animated: true)
        }
        else {
            let controller = AlertController(title: nil,
                                             message: LS.mapUserLocationError,
                                             preferredStyle: UIAlertControllerStyle.alert)
            controller.tintColor = UIColor.ttAlternateTintColor()
            controller.addAction(UIAlertAction(title: LS.genericOKButton,
                                               style: .default,
                                               handler: nil))
            context.present(controller, animated: true, completion: nil)
        }
    }

    func replaceCurrentRoutes(with routes: [TrolleyRoute]) {

        removeTrolleyRoutesAndStops()

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

    func addOrUpdateTrolley(_ trolleys: [Trolley]) {

        // Get our Trolley Annotations
        let existing = trolleyAnnotations

        let trolleysToAdd = trolleys.filter {
            !existing.contains($0)
        }
        let trolleysToUpdate = trolleys.filter {
            existing.contains($0)
        }
        let trolleysToRemove = existing.filter {
            !trolleys.contains($0)
        }

        for trolley in trolleysToUpdate {
            guard let index = existing.index(of: trolley) else { continue }
            let existingAnnotation = existing[index]
            existingAnnotation.coordinate = trolley.coordinate
            // TODO: Update trolley annotation color if needed
        }

        removeAnnotations(trolleysToRemove)
        addAnnotations(trolleysToAdd)
    }

    func setRegionToDowntownGreenville() {
        region = .downtownGreenville
    }

    func removeTrolleyRoutesAndStops() {
        removeOverlays(trolleyRouteOverlays)
        removeAnnotations(trolleyStopAnnotations)
    }

    func reloadRouteOverlays() {
        let current = trolleyRouteOverlays
        removeOverlays(trolleyRouteOverlays)
        addOverlays(current)
    }

    func dimTrolleyAnnotationsExcept(_ annotationToSkip: MKAnnotationView) {
        for annotation in trolleyAnnotations {
            guard let view = self.view(for: annotation) else { continue }
            guard view != annotationToSkip else { continue }
            view.alpha = .fadedTrolley
        }
    }

    func undimAllTrolleyAnnotations() {
        for annotation in trolleyAnnotations {
            view(for: annotation)?.alpha = .unfadedTrolley
        }
    }

    func setStops(faded: Bool) {
        for annotation in trolleyStopAnnotations {
            view(for: annotation)?.alpha = faded ? .fadedStop : .unfadedStop
        }
    }
}

extension MKCoordinateRegion {
    static var downtownGreenville: MKCoordinateRegion {
        return MKCoordinateRegion(center: .downtownGreenville,
                                  span: .defaultSpan)
    }
}

extension CLLocationCoordinate2D {
    static var downtownGreenville: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(34.851887, -82.398366)
    }
}

extension MKCoordinateSpan {
    static var defaultSpan: MKCoordinateSpan {
        return MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    }
}
