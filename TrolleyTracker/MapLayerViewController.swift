//
//  MapLayerViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class MapLayerViewController: UIViewController, StoryboardInjectable {

    typealias ViewControllerDependencies = MapLayerItemCollection

    private let collection: MapLayerItemCollection
    @IBOutlet var mapView: MKMapView!

    required init?(coder aDecoder: NSCoder) {
        self.collection = MapLayerViewController.getDependencies()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.setRegionToDowntownGreenville()

        title = collection.name

        let annotations = collection.items.map { $0.annotation() }
        mapView.addAnnotations(annotations)
    }
}

extension MapLayerViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
}
