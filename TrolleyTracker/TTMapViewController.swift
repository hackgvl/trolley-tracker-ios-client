//
//  TTMapViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

extension TTTrolley: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String! {
        return name
    }
    
    var subTitle: String! {
        return ""
    }
}

extension TTTrolleyStop: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    var title: String! {
        // TODO: Return Trolley Name
        return name
    }
    
    var subTitle: String! {
        return ""
    }
}

// TODO: Add tracking button that toggles MKUserTrackingMode like native maps

class TTMapViewController: UIViewController, MKMapViewDelegate, TTDetailViewControllerDelegate {
    
    //==================================================================
    // MARK: - Properties
    //==================================================================
    
    lazy var detailViewController: TTDetailViewController = {
        let controller = TTDetailViewController()
        controller.delegate = self
        return controller
    }()
    
    private var detailViewVisibleConstraint: NSLayoutConstraint?
    private var detailViewHiddenConstraint: NSLayoutConstraint?
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        TTTrolleyLocationService.sharedService.trolleyObservers.add(updateTrolley)
        TTTrolleyLocationService.sharedService.startTrackingTrolleys()
        
        loadStops()
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    private func updateTrolley(trolley: TTTrolley) {
        
        // Grab a reference to the detailViewController's currentAnnotation (if any), before it disappears when we remove the current annotation.
        let detailViewAnnotation = detailViewController.currentlyShowingAnnotation
        
        // Get our Trolley Annotations
        let trolleyAnnotations = mapView.annotations.filter { $0 is TTTrolley }.map { $0 as! TTTrolley }
        
        if let index = find(trolleyAnnotations, trolley) {
            let existingAnnotation = trolleyAnnotations[index]
            mapView.removeAnnotation(existingAnnotation)
        }
        
        mapView.addAnnotation(trolley)
        
        // If the detailViewController was showing this trolley, update it
        if let annotation = detailViewAnnotation as? TTTrolley where annotation == trolley {
            detailViewController.showDetailForAnnotation(trolley)
        }
    }
    
    private func loadStops() {
        
        // Get Stops
        TTTrolleyStopService.sharedService.loadTrolleyStops { (stops) -> Void in
            // Plot each stop as an annotation on the MapView
            stops.map { trolleyStop -> () in
                self.mapView.addAnnotation(trolleyStop)
            }
        }
    }
    
    private func setDetailViewVisible(visible: Bool, animated: Bool) {
        
        detailViewHiddenConstraint?.active = !visible
        detailViewVisibleConstraint?.active = visible
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animateWithDuration(0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    //==========================================================================
    // MARK: - MKMapViewDelegate
    //==========================================================================
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let stopViewID = "stopView"
        let trolleyViewID = "trolleyViewID"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(stopViewID)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: stopViewID)
            annotationView.image = UIImage(named:"Stop_sign")
            //            annotationView.canShowCallout = true
        }
        else {
            //we are re-using a view, update its annotation reference...
            annotationView.annotation = annotation
        }
        
        // Handle Trolleys
        if let trolleyAnnotation = annotation as? TTTrolley {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(trolleyAnnotationReuseIdentifier)
            
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
            }
            
            annotationView.annotation = trolleyAnnotation
            
            return annotationView
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        detailViewController.showDetailForAnnotation(view.annotation)
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        detailViewController.showDetailForAnnotation(nil)
    }
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
//        mapView.setRegion(region, animated: true)
//    }
    
    //==================================================================
    // MARK: - TTDetailViewControllerDelegate
    //==================================================================
    
    func detailViewControllerWantsToShow(controller: TTDetailViewController) {
        setDetailViewVisible(true, animated: true)
    }
    
    func detailViewControllerWantsToHide(controller: TTDetailViewController) {
        setDetailViewVisible(false, animated: true)
    }
    
    //==========================================================================
    // mark: Views
    //==========================================================================
    
    private func setupViews() {
        
        title = "Trolly Tracker"
        
        view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .Plain, target: self, action:"showSettings")
        
        view.addSubview(detailView)
        view.addSubview(mapView)
        
        self.addChildViewController(detailViewController)
        detailView.addSubview(detailViewController.view)
        detailViewController.view.frame = detailView.bounds
        detailViewController.didMoveToParentViewController(self)
        
        let views = ["detailView": detailView, "mapView": mapView]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailView]|", options: nil, metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: nil, metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView][detailView]", options: nil, metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: detailView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.3, constant: 0.0)])
        
        detailViewVisibleConstraint = NSLayoutConstraint(item: detailView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        detailViewHiddenConstraint = NSLayoutConstraint(item: detailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        setDetailViewVisible(false, animated: false)
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        mapView.mapType = MKMapType.Standard
        
        mapView.showsUserLocation = true
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        
        mapView.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(34.851887, -82.398366), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        mapView.delegate = self
        
        return mapView
        }()
    
    lazy var detailView: UIView = {
        let detailView = UIView()
        detailView.setTranslatesAutoresizingMaskIntoConstraints(false)
        return detailView
        }()
    
    //==========================================================================
    // mark: Actions
    //==========================================================================
    
    func showSettings() {
        var settingsViewController = TTSettingsViewController()
        
        var navController = UINavigationController(rootViewController: settingsViewController)
        
        self.presentViewController(navController, animated: true, completion: nil)
    }
}