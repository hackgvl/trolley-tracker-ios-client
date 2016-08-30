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
    fileprivate let mapViewDelegate = TrolleyMapViewDelegate()
    fileprivate var trolleyRouteService: TrolleyRouteService!
    
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //==================================================================
    // MARK: - Implementation
    //==================================================================
    
    fileprivate final func setupEnvironmentDependentItems() {
        switch EnvironmentVariables.currentBuildConfiguration() {
        case .Release:
            trolleyRouteService = TrolleyRouteServiceLive.sharedService
        case .Test:
            trolleyRouteService = TrolleyRouteServiceFake()
        }
    }
    
    fileprivate final func displayRoute() {
        
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
            self.mapView.add(route.overlay)
            
            for stop in route.stops {
                self.mapView.addAnnotation(stop)
            }
        }
    }
    
    fileprivate final func setDimmingOverlayVisible(_ visible: Bool, animated: Bool) {
        
        self.dimmingView.isHidden = false
        
        let duration = 0.25
        let changes = { self.dimmingView.alpha = visible ? 1 : 0 }
        let completion: (Bool) -> Void = { finished in if !visible { self.dimmingView.isHidden = true } }
        
        if animated { UIView.animate(withDuration: duration, animations: changes, completion: completion) }
        else { changes(); completion(true) }
    }
}
