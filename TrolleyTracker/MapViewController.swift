//
//  TTMapViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

// TODO: Add tracking button that toggles MKUserTrackingMode like native maps

class MapViewController: UIViewController, MKMapViewDelegate, DetailViewControllerDelegate {
    
    //==================================================================
    // MARK: - Properties
    //==================================================================
    
    lazy var detailViewController: DetailViewController = {
        let controller = DetailViewController()
        controller.delegate = self
        return controller
    }()
    
    private var detailViewVisibleConstraint: NSLayoutConstraint?
    private var detailViewHiddenConstraint: NSLayoutConstraint?
    
    private let locationManager = CLLocationManager()
    
    private var lastRouteLoadTime: NSDate?
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        let titleView = UIView()
        titleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        navigationItem.titleView = titleView
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title]-|", options: nil, metrics: nil, views: ["title" : titleView]))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: titleView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView.superview!, attribute: .CenterX, multiplier: 1.0, constant: 0.0)])
        
        let titleImageView = UIImageView(image: UIImage.ttTrolleyTrackerLogo)
        titleImageView.contentMode = UIViewContentMode.ScaleAspectFit
        titleImageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleView.addSubview(titleImageView)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|", options: nil, metrics: nil, views: ["image" : titleImageView]))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: titleImageView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)])
        
        TrolleyLocationService.sharedService.trolleyObservers.add(updateTrolley)
        TrolleyLocationService.sharedService.startTrackingTrolleys()
        
        locationManager.requestWhenInUseAuthorization()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let maxRouteTime: NSTimeInterval = 15 * 60
        if lastRouteLoadTime == nil || lastRouteLoadTime?.timeIntervalSinceNow < -maxRouteTime {
            loadRoutes()
        }
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    private func updateTrolley(trolley: Trolley) {
        
        // Grab a reference to the detailViewController's currentAnnotation (if any), before it disappears when we remove the current annotation.
        let detailViewAnnotation = detailViewController.currentlyShowingAnnotation
        
        // Get our Trolley Annotations
        let trolleyAnnotations = mapView.annotations.filter { $0 is Trolley }.map { $0 as! Trolley }
        
        if let index = find(trolleyAnnotations, trolley) {
            let existingAnnotation = trolleyAnnotations[index]
            mapView.removeAnnotation(existingAnnotation)
        }
        
        mapView.addAnnotation(trolley)
        
        // If the detailViewController was showing this trolley, update it
        if let annotation = detailViewAnnotation as? Trolley where annotation == trolley {
            detailViewController.showDetailForAnnotation(trolley, withUserLocation: mapView.userLocation)
        }
    }
    
    private func loadRoutes() {
        
        // Get Stops
        TrolleyRouteService.sharedService.loadTrolleyRoutes { routes in
            // For each route,
            for (index, var route) in enumerate(routes) {
                
                // -- Assign a color
                let routeColor = UIColor.routeColors[index % UIColor.routeColors.count]
                
                // -- Add overlays
                self.mapView.addOverlay(route.overlay)
                
                // -- Add stops
                for stop in route.stops {
                    self.mapView.addAnnotation(stop)
                }
            }
            self.lastRouteLoadTime = NSDate()
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
        
        // Handle Stops
        if let stopAnnotation = annotation as? TrolleyStop {
            
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(stopAnnotationReuseIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: stopAnnotationReuseIdentifier)
            }
            
            annotationView.annotation = annotation
            annotationView.tintColor = UIColor.stopColorForIndex(stopAnnotation.colorIndex)
            annotationView.setTintedImage(UIImage.ttTrolleyStopPin)
            annotationView.centerOffset = CGPointMake(0, -(annotationView.image.size.height / 2))
            
            return annotationView
        }
        
        
        // Handle Trolleys
        if let trolleyAnnotation = annotation as? Trolley {
            
            var annotationView: TrolleyAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(trolleyAnnotationReuseIdentifier) as? TrolleyAnnotationView
            if annotationView == nil {
                annotationView = TrolleyAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
            }
            
            annotationView.tintColor = UIColor.trolleyColorForID(trolleyAnnotation.ID)
            annotationView.frame = CGRectMake(0, 0, 50, 50)
            annotationView.trolleyNumber = trolleyAnnotation.ID
            annotationView.annotation = trolleyAnnotation
            dispatch_async(dispatch_get_main_queue()) {
                annotationView.superview?.bringSubviewToFront(annotationView)
            }
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.lineWidth = 6.0
        
        if let routeOverlay = overlay as? TrolleyRouteOverlay {
            renderer.strokeColor = UIColor.routeColorForIndex(routeOverlay.colorIndex)
        }
        
        return renderer
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        detailViewController.showDetailForAnnotation(view.annotation, withUserLocation: mapView.userLocation)
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        detailViewController.showDetailForAnnotation(nil, withUserLocation: nil)
    }
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
//        mapView.setRegion(region, animated: true)
//    }
    
    //==================================================================
    // MARK: - TTDetailViewControllerDelegate
    //==================================================================
    
    func detailViewControllerWantsToShow(controller: DetailViewController) {
        setDetailViewVisible(true, animated: true)
    }
    
    func detailViewControllerWantsToHide(controller: DetailViewController) {
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
        
        let settingsViewController = TTSettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
}