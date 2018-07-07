//
//  MapController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

protocol MapControllerDelegate: class {
    func annotationSelected(_ annotation: MKAnnotationView?,
                            userLocation: MKUserLocation?)
    func handleNoTrolleysUpdate(_ trolleysPresent: Bool)
}

class MapController: FunctionController {

    typealias Dependencies = HasModelController

    weak var delegate: MapControllerDelegate?

    private let viewController: MapViewController
    private let dependencies: Dependencies
    private let locationManager = CLLocationManager()
    private let mapDelegate = TrolleyMapViewDelegate()

    private let refreshTimer = RefreshTimer(interval: 60)

    private var modelController: ModelController {
        return dependencies.modelController
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.viewController = MapViewController()
    }

    func prepare() -> UIViewController {

        viewController.delegate = self

        locationManager.requestWhenInUseAuthorization()

        modelController.trolleyObservers.add(handleTrolleyUpdate(_:))

        viewController.mapView.showsUserLocation = true
        viewController.mapView.setRegionToDowntownGreenville()
        viewController.mapView.delegate = mapDelegate

        mapDelegate.annotationSelectionAction = { view in
            self.undimAllItems()
            let user = self.viewController.mapView.userLocation
            self.delegate?.annotationSelected(view,
                                              userLocation: user)
            self.dimItemsNotRelated(toView: view)
        }
        mapDelegate.annotationDeselectionAction = { view in
            self.delegate?.annotationSelected(nil, userLocation: nil)
            self.undimAllItems()
        }

        refreshTimer.action = loadRoutes

        return viewController
    }

    private func handleTrolleyUpdate(_ trolleys: [Trolley]) {
        viewController.mapView.addOrUpdateTrolley(trolleys)
        delegate?.handleNoTrolleysUpdate(!trolleys.isEmpty)
    }

    private func loadRoutes() {
        modelController.loadTrolleyRoutes { routes in
            self.viewController.mapView.replaceCurrentRoutes(with: routes)
        }
    }

    private func dimItemsNotRelated(toView view: MKAnnotationView) {
        guard let trolleyView = view as? TrolleyAnnotationView,
            let trolley = trolleyView.annotation as? Trolley,
            let route = modelController.route(for: trolley) else {
                return
        }

        mapDelegate.highlightedTrolley = trolley
        mapDelegate.highlightedRoute = route
        mapDelegate.shouldDimStops = true

        viewController.mapView.setStops(faded: true)
        viewController.mapView.reloadRouteOverlays()
        viewController.dimTrolleysOtherThan(trolley)
    }

    private func undimAllItems() {
        mapDelegate.highlightedTrolley = nil
        mapDelegate.highlightedRoute = nil
        mapDelegate.shouldDimStops = false
        viewController.mapView.undimAllTrolleyAnnotations()
        viewController.mapView.reloadRouteOverlays()
        viewController.mapView.setStops(faded: false)
    }

    func unobscure(_ view: UIView) {
        guard
            let annotationView = view as? MKAnnotationView,
            let annotation = annotationView.annotation
            else { return }
        viewController.mapView.setCenter(annotation.coordinate, animated: true)
    }
}

extension MapController: MapVCDelegate {

    func locateMeButtonTapped() {
        viewController.mapView.centerOnUser(context: viewController)
    }

    func annotationSelected(_ annotation: MKAnnotationView?,
                            userLocation: MKUserLocation?) {
        delegate?.annotationSelected(annotation, userLocation: userLocation)
    }

    func viewAppeared() {
        loadRoutes()
        modelController.startTrackingTrolleys()
        refreshTimer.start()
    }

    func viewDisappeared() {
        refreshTimer.stop()
        modelController.stopTrackingTrolleys()
    }
}
