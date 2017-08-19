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
    func annotationSelected(_ annotation: MKAnnotation?,
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
            let user = self.viewController.mapView.userLocation
            self.delegate?.annotationSelected(view.annotation,
                                              userLocation: user)
        }
        mapDelegate.annotationDeselectionAction = { view in
            self.delegate?.annotationSelected(nil, userLocation: nil)
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
}

extension MapController: MapVCDelegate {

    func locateMeButtonTapped() {
        viewController.mapView.centerOnUser(context: viewController)
    }

    func annotationSelected(_ annotation: MKAnnotation?,
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
