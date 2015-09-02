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
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.delegate = self
        return controller
    }()
    
    private var detailViewVisibleConstraint: NSLayoutConstraint?
    private var detailViewHiddenConstraint: NSLayoutConstraint?
    
    private var noTrolleyHiddenConstraint: NSLayoutConstraint?
    private var noTrolleyVisibleConstraint: NSLayoutConstraint?
    
    private let locationManager = CLLocationManager()
    
    private var lastRouteLoadTime: NSDate?
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        let titleView = UIView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = titleView
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[title]-|", options: [], metrics: nil, views: ["title" : titleView]))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: titleView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView.superview!, attribute: .CenterX, multiplier: 1.0, constant: 0.0)])
        
        let titleImageView = UIImageView(image: UIImage.ttTrolleyTrackerLogo)
        titleImageView.contentMode = UIViewContentMode.ScaleAspectFit
        titleImageView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleImageView)
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[image]|", options: [], metrics: nil, views: ["image" : titleImageView]))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: titleImageView, attribute: .CenterX, relatedBy: .Equal, toItem: titleView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)])
        
        TrolleyLocationService.sharedService.trolleyPresentObservers.add(updateTrolleyPresent)
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
        
        // Get our Trolley Annotations
        let trolleyAnnotations = mapView.annotations.filter { $0 is Trolley }.map { $0 as! Trolley }
        
        // If we're already showing this Trolly on the map, just update it
        if let index = trolleyAnnotations.indexOf(trolley) {
            let existingAnnotation = trolleyAnnotations[index]
            existingAnnotation.coordinate = trolley.location.coordinate
        }
        // Otherwise, add it
        else {
            mapView.addAnnotation(trolley)
        }
    }
    
    private func updateTrolleyPresent(present: Bool) {
        setNoTrolleyMessageVisible(!present, animated: true)
    }
    
    private func loadRoutes() {
        
        // Get Stops
        TrolleyRouteService.sharedService.loadTrolleyRoutes { routes in
            // For each route,
            for var route in routes {
                
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
        
        if visible {
            detailViewHiddenConstraint?.active = false
            detailViewVisibleConstraint?.active = true
        }
        else {
            detailViewVisibleConstraint?.active = false
            detailViewHiddenConstraint?.active = true
        }
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animateWithDuration(0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    private func setNoTrolleyMessageVisible(visible: Bool, animated: Bool) {
        
        if visible {
            noTrolleyHiddenConstraint?.active = false
            noTrolleyVisibleConstraint?.active = true
        }
        else {
            noTrolleyVisibleConstraint?.active = false
            noTrolleyHiddenConstraint?.active = true
        }
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animateWithDuration(0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    //==========================================================================
    // MARK: - MKMapViewDelegate
    //==========================================================================
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    let userAnnotationReuseIdentifier = "UserAnnotation"
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var returnView: MKAnnotationView?
        
        if (annotation is MKUserLocation) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(userAnnotationReuseIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userAnnotationReuseIdentifier)
                annotationView!.image = UIImage.ttUserPin
                annotationView!.centerOffset = CGPointMake(0, -(annotationView!.image!.size.height / 2))
            }
            
            annotationView!.annotation = annotation

            returnView = annotationView
        }
        
        // Handle Stops
        else if let stopAnnotation = annotation as? TrolleyStop {
            
            var annotationView: TrolleyStopAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(stopAnnotationReuseIdentifier) as? TrolleyStopAnnotationView
            if annotationView == nil {
                annotationView = TrolleyStopAnnotationView(annotation: annotation, reuseIdentifier: stopAnnotationReuseIdentifier)
                annotationView.frame = CGRectMake(0, 0, 30, 50)
                annotationView.centerOffset = CGPointMake(0, -(CGRectGetHeight(annotationView.frame) / 2))
            }
            
            annotationView.annotation = annotation
            annotationView.tintColor = UIColor.stopColorForIndex(stopAnnotation.colorIndex)
            
            returnView = annotationView
        }
        
        
        // Handle Trolleys
        else if let trolleyAnnotation = annotation as? Trolley {
            
            var annotationView: TrolleyAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(trolleyAnnotationReuseIdentifier) as? TrolleyAnnotationView
            if annotationView == nil {
                annotationView = TrolleyAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
                annotationView.frame = CGRectMake(0, 0, 50, 50)
            }
            
            annotationView.tintColor = UIColor.trolleyColorForID(trolleyAnnotation.ID)
            annotationView.trolleyNumber = trolleyAnnotation.ID
            annotationView.annotation = trolleyAnnotation
            
            returnView = annotationView
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.updateAnnotationZIndexes()
        }
        
        return returnView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.lineWidth = 6.0
        
        if let routeOverlay = overlay as? TrolleyRouteOverlay {
            renderer.strokeColor = UIColor.routeColorForIndex(routeOverlay.colorIndex)
        }
        
        return renderer
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        detailViewController.showDetailForAnnotation(view.annotation, withUserLocation: mapView.userLocation)
        updateAnnotationZIndexes()
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        detailViewController.showDetailForAnnotation(nil, withUserLocation: nil)
        updateAnnotationZIndexes()
    }
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
//        mapView.setRegion(region, animated: true)
//    }
    
    private func updateAnnotationZIndexes() {
        
        for annotation in mapView.annotations {
            if let trolley = annotation as? Trolley,
            view = mapView.viewForAnnotation(trolley) {
                view.superview?.bringSubviewToFront(view)
            }
        }
        
        if let view = mapView.viewForAnnotation(mapView.userLocation) {
            view.superview?.bringSubviewToFront(view)
        }
    }
    
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
    // MARK: - Actions
    //==========================================================================
    
    func showSettings() {
        
        let settingsViewController = TTSettingsViewController()
        let navController = UINavigationController(rootViewController: settingsViewController)
        self.presentViewController(navController, animated: true, completion: nil)
    }
    
    func handleLocateMeButton(sender: UIButton) {
        let userLocation = mapView.userLocation.coordinate
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            mapView.setCenterCoordinate(userLocation, animated: true)
        }
        else {
            let controller = UIAlertController(title: nil, message: "We're sorry, we can't find your current location right now.", preferredStyle: UIAlertControllerStyle.Alert)
            controller.view.tintColor = UIColor.ttAlternateTintColor()
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    private func setupViews() {
        
        title = "Trolly Tracker"
        
        view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .Plain, target: self, action:"showSettings")
        
        view.addSubview(detailView)
        view.addSubview(mapView)
        
        mapView.addSubview(locateMeButton)
        mapView.insertSubview(noTrolleyLabel, belowSubview: detailView)
        
        let views = ["detailView": detailView, "detailControllerView" : detailViewController.view, "mapView": mapView, "locateMe": locateMeButton, "noTrolleyLabel": noTrolleyLabel]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView][detailView]", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: detailView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.3, constant: 0.0)])
        
        detailViewVisibleConstraint = NSLayoutConstraint(item: detailView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        detailViewHiddenConstraint = NSLayoutConstraint(item: detailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[noTrolleyLabel]|", options: [], metrics: nil, views: views))
        noTrolleyVisibleConstraint = NSLayoutConstraint(item: noTrolleyLabel, attribute: .Bottom, relatedBy: .Equal, toItem: detailView, attribute: .Top, multiplier: 1.0, constant: 0)
        noTrolleyHiddenConstraint = NSLayoutConstraint(item: noTrolleyLabel, attribute: .Top, relatedBy: .Equal, toItem: detailView, attribute: .Top, multiplier: 1.0, constant: 0)
        
        setNoTrolleyMessageVisible(false, animated: false)
        setDetailViewVisible(false, animated: false)
        
        view.layoutIfNeeded()
        detailView.layoutIfNeeded()
        
        self.addChildViewController(detailViewController)
        detailView.addSubview(detailViewController.view)
        detailViewController.didMoveToParentViewController(self)
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailControllerView]|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[detailControllerView]|", options: [], metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[locateMe]-12-|", options: [], metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[locateMe]-12-|", options: [], metrics: nil, views: views))
        let buttonSize: CGFloat = 44
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: locateMeButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonSize)])
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: locateMeButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: buttonSize)])
    }
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
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
        detailView.translatesAutoresizingMaskIntoConstraints = false
        return detailView
        }()
    
    lazy var locateMeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.ttAlternateTintColor()
        button.tintColor = UIColor.ttTintColor()
        button.layer.cornerRadius = 5
        button.setImage(UIImage.ttLocateMe, forState: .Normal)
        button.addTarget(self, action: "handleLocateMeButton:", forControlEvents: .TouchUpInside)
        return button
        }()
    
    lazy var noTrolleyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.ttLightGreen()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.text = "No Trolleys are being tracked right now."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}