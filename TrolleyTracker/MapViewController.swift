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
    
    var trolleyRouteService: TrolleyRouteService!
    var trolleyLocationService: TrolleyLocationService!
    
    var detailViewController: DetailViewController!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var locateMeButton: UIButton!
    @IBOutlet var noTrolleyLabel: UILabel!
    
    @IBOutlet var noTrolleyLabelTapGesture: UITapGestureRecognizer!
    
    @IBOutlet var detailViewVisibleConstraint: NSLayoutConstraint!
    private var detailViewHiddenConstraint: NSLayoutConstraint!
    
    private var noTrolleyHiddenConstraint: NSLayoutConstraint!
    @IBOutlet var noTrolleyVisibleConstraint: NSLayoutConstraint!
    
    private let locationManager = CLLocationManager()
    
    private var lastRouteLoadTime: NSDate?
    
    private var mapViewDelegate: TrolleyMapViewDelegate!
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch EnvironmentVariables.currentBuildConfiguration() {
        case .Release:
            trolleyLocationService = TrolleyLocationServiceLive.sharedService
            trolleyRouteService = TrolleyRouteServiceLive.sharedService
        case .Test:
            trolleyLocationService = TrolleyLocationServiceFake()
            trolleyRouteService = TrolleyRouteServiceFake()
        }
        
        
        setupViews()
        
        mapViewDelegate = TrolleyMapViewDelegate()
        mapViewDelegate.annotationSelectionAction = { [unowned self] view in
            self.detailViewController.showDetailForAnnotation(view.annotation, withUserLocation: self.mapView.userLocation)
        }
        mapViewDelegate.annotationDeselectionAction = { [unowned self] view in
            self.detailViewController.showDetailForAnnotation(nil, withUserLocation: nil)
        }
        mapView.delegate = mapViewDelegate
        
        trolleyLocationService.trolleyPresentObservers.add(updateTrolleyPresent)
        trolleyLocationService.trolleyObservers.add(updateTrolley)
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.setRegionToDowntownGreenville()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let maxRouteTime: NSTimeInterval = 15 * 60
        if lastRouteLoadTime == nil || lastRouteLoadTime?.timeIntervalSinceNow < -maxRouteTime {
            loadRoutes()
        }
        
        trolleyLocationService.startTrackingTrolleys()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        trolleyLocationService.stopTrackingTrolley()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailController = segue.destinationViewController as? DetailViewController {
            self.detailViewController = detailController
            detailController.delegate = self 
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
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
        trolleyRouteService.loadTrolleyRoutes { routes in
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
            noTrolleyHiddenConstraint.active = false
            noTrolleyVisibleConstraint.active = true
        }
        else {
            noTrolleyVisibleConstraint.active = false
            noTrolleyHiddenConstraint.active = true
        }
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animateWithDuration(0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    @IBAction func handleNoTrolleyLabelTap(sender: UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 1
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
    
    @IBAction func handleLocateMeButton(sender: UIButton) {
        let userLocation = mapView.userLocation.coordinate
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            mapView.setCenterCoordinate(userLocation, animated: true)
        }
        else {
            let controller = AlertController(title: nil, message: "We're sorry, we can't find your current location right now.", preferredStyle: UIAlertControllerStyle.Alert)
            controller.tintColor = UIColor.ttAlternateTintColor()
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    private func setupViews() {
        
        title = "Map"
        noTrolleyLabel.text = "No Trolleys are being tracked right now.\nView the Schedule to see run times and select a route to preview it on the map."
        
        view.backgroundColor = UIColor.whiteColor()
        
        noTrolleyLabel.backgroundColor = UIColor.ttLightGreen()
        noTrolleyLabel.textColor = UIColor.whiteColor()
        
        locateMeButton.backgroundColor = UIColor.ttAlternateTintColor()
        locateMeButton.tintColor = UIColor.ttTintColor()
        locateMeButton.layer.cornerRadius = 5
        
        detailViewHiddenConstraint = NSLayoutConstraint(item: detailView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        noTrolleyHiddenConstraint = NSLayoutConstraint(item: noTrolleyLabel, attribute: .Top, relatedBy: .Equal, toItem: mapView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        setNoTrolleyMessageVisible(false, animated: false)
        setDetailViewVisible(false, animated: false)
    }
}