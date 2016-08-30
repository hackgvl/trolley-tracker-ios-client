//
//  TTMapViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


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
    fileprivate var detailViewHiddenConstraint: NSLayoutConstraint!
    
    fileprivate var noTrolleyHiddenConstraint: NSLayoutConstraint!
    @IBOutlet var noTrolleyVisibleConstraint: NSLayoutConstraint!
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate var lastRouteLoadTime: Date?
    
    fileprivate var mapViewDelegate: TrolleyMapViewDelegate!
    
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
        
        let _ = trolleyLocationService.trolleyPresentObservers.add(updateTrolleyPresent)
        let _ = trolleyLocationService.trolleyObservers.add(updateTrolley)
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.setRegionToDowntownGreenville()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let maxRouteTime: TimeInterval = 15 * 60
        if lastRouteLoadTime == nil || lastRouteLoadTime?.timeIntervalSinceNow < -maxRouteTime {
            loadRoutes()
        }
        
        trolleyLocationService.startTrackingTrolleys()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        trolleyLocationService.stopTrackingTrolley()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController = segue.destination as? DetailViewController {
            self.detailViewController = detailController
            detailController.delegate = self 
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    fileprivate func updateTrolley(_ trolley: Trolley) {
        
        // Get our Trolley Annotations
        let trolleyAnnotations = mapView.annotations.filter { $0 is Trolley }.map { $0 as! Trolley }
        
        // If we're already showing this Trolly on the map, just update it
        if let index = trolleyAnnotations.index(of: trolley) {
            let existingAnnotation = trolleyAnnotations[index]
            existingAnnotation.coordinate = trolley.location.coordinate
        }
        // Otherwise, add it
        else {
            mapView.addAnnotation(trolley)
        }
    }
    
    fileprivate func updateTrolleyPresent(_ present: Bool) {
        setNoTrolleyMessageVisible(!present, animated: true)
    }
    
    fileprivate func loadRoutes() {
        
        // Get Stops
        trolleyRouteService.loadTrolleyRoutes { routes in
            // For each route,
            for var route in routes {
                
                // -- Add overlays
                self.mapView.add(route.overlay)
                
                // -- Add stops
                for stop in route.stops {
                    self.mapView.addAnnotation(stop)
                }
            }
            self.lastRouteLoadTime = Date()
        }
    }
    
    fileprivate func setDetailViewVisible(_ visible: Bool, animated: Bool) {
        
        if visible {
            detailViewHiddenConstraint?.isActive = false
            detailViewVisibleConstraint?.isActive = true
        }
        else {
            detailViewVisibleConstraint?.isActive = false
            detailViewHiddenConstraint?.isActive = true
        }
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animate(withDuration: 0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    fileprivate func setNoTrolleyMessageVisible(_ visible: Bool, animated: Bool) {
        
        if visible {
            noTrolleyHiddenConstraint.isActive = false
            noTrolleyVisibleConstraint.isActive = true
        }
        else {
            noTrolleyVisibleConstraint.isActive = false
            noTrolleyHiddenConstraint.isActive = true
        }
        
        let updateAction = { self.view.layoutIfNeeded() }
        
        if animated { UIView.animate(withDuration: 0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    @IBAction func handleNoTrolleyLabelTap(_ sender: UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 1
    }
    
    //==================================================================
    // MARK: - TTDetailViewControllerDelegate
    //==================================================================
    
    func detailViewControllerWantsToShow(_ controller: DetailViewController) {
        setDetailViewVisible(true, animated: true)
    }
    
    func detailViewControllerWantsToHide(_ controller: DetailViewController) {
        setDetailViewVisible(false, animated: true)
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    @IBAction func handleLocateMeButton(_ sender: UIButton) {
        let userLocation = mapView.userLocation.coordinate
        if userLocation.latitude != 0 && userLocation.longitude != 0 {
            mapView.setCenter(userLocation, animated: true)
        }
        else {
            let controller = AlertController(title: nil, message: "We're sorry, we can't find your current location right now.", preferredStyle: UIAlertControllerStyle.alert)
            controller.tintColor = UIColor.ttAlternateTintColor()
            controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            present(controller, animated: true, completion: nil)
        }
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    fileprivate func setupViews() {
        
        title = "Map"
        noTrolleyLabel.text = "No Trolleys are being tracked right now.\nView the Schedule to see run times and select a route to preview it on the map."
        
        view.backgroundColor = UIColor.white
        
        noTrolleyLabel.backgroundColor = UIColor.ttLightGreen()
        noTrolleyLabel.textColor = UIColor.white
        
        locateMeButton.backgroundColor = UIColor.ttAlternateTintColor()
        locateMeButton.tintColor = UIColor.ttTintColor()
        locateMeButton.layer.cornerRadius = 5
        
        detailViewHiddenConstraint = NSLayoutConstraint(item: detailView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        noTrolleyHiddenConstraint = NSLayoutConstraint(item: noTrolleyLabel, attribute: .top, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        setNoTrolleyMessageVisible(false, animated: false)
        setDetailViewVisible(false, animated: false)
    }
}
