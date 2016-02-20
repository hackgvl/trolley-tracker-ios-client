//
//  RouteDetailViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 2/20/16.
//  Copyright © 2016 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, MKMapViewDelegate {

    //==================================================================
    // MARK: - Variables
    //==================================================================
    
    var routeID: Int?
    private let mapViewDelegate = TrolleyMapViewDelegate()
    private var trolleyRouteService: TrolleyRouteService!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var routeNameLabel: UILabel!
    @IBOutlet var dimmingView: UIView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    
    //==================================================================
    // MARK: - UIViewController Overrides
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupEnvironmentDependentItems()
        mapViewDelegate.shouldShowCallouts = true
        mapView.delegate = mapViewDelegate
        mapView.setRegionToDowntownGreenville()
        displayRoute()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .Black
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    //==================================================================
    // MARK: - Implementation
    //==================================================================
    
    private final func setupEnvironmentDependentItems() {
        switch EnvironmentVariables.currentBuildConfiguration() {
        case .Release:
            trolleyRouteService = TrolleyRouteServiceLive.sharedService
        case .Test:
            trolleyRouteService = TrolleyRouteServiceFake()
        }
    }
    
    private final func displayRoute() {
        
        routeNameLabel.text = nil
        setDimmingOverlayVisible(true, animated: true)
        
        guard let id = routeID else {
            assert(false, "Trying to display a Route Detail ViewController with no routeID, this will not end well.")
            return
        }
        
        trolleyRouteService.loadTrolleyRoute(id) { routes in
            
            guard var route = routes.first else { return }
            
            self.setDimmingOverlayVisible(false, animated: true)
            self.routeNameLabel.text = route.longName
            self.mapView.addOverlay(route.overlay)
            
            for stop in route.stops {
                self.mapView.addAnnotation(stop)
            }
        }
    }
    
    private final func setDimmingOverlayVisible(visible: Bool, animated: Bool) {
        
        self.dimmingView.hidden = false
        
        let duration = 0.25
        let changes = { self.dimmingView.alpha = visible ? 1 : 0 }
        let completion: (Bool) -> Void = { finished in if !visible { self.dimmingView.hidden = true } }
        
        if animated { UIView.animateWithDuration(duration, animations: changes, completion: completion) }
        else { changes(); completion(true) }
    }
}
