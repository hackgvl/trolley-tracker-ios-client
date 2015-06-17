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
        return identifier
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

class TTMapViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trolly Tracker"
        
        view.backgroundColor = UIColor.whiteColor()
        let detailViewController: TTDetailViewController = TTDetailViewController();
        self.view.addSubview(detailView)
        view.addSubview(mapView)
        
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .Plain, target: self, action:"showSettings")
        self.addChildViewController(detailViewController)
        view.addSubview(detailViewController.view)
        detailViewController.didMoveToParentViewController(self)
        
        let views = ["detailView": detailView, "mapView": mapView]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailView]|", options: nil, metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: nil, metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView][detailView(==mapView)]|", options: nil, metrics: nil, views: views))
        
        
        TTTrolleyLocationService.sharedService.trolleyObservers.add(updateTrolley)
        TTTrolleyLocationService.sharedService.startTrackingTrolleys()
    }
    
    func updateTrolley(trolley: TTTrolley) {
        println("updateTroller")
        
        self.mapView.addAnnotation(trolley)
    }
    
    func loadStops() {
        // TODO: Get Stops
        let stops: [TTTrolleyStop] = []
        
        // Plot each stop as an annotation on the MapView
        stops.map {
            trolleyStop -> () in
            
            self.mapView.addAnnotation(trolleyStop)
        }
    }
    
    func loadTrolleys() {
        // TODO: Get Trolleys
        let trolleys: [TTTrolley] = []
        
        // Plot each Trolley as an annotation on the MapView
        trolleys.map {
            trolleyStop -> () in
            
            self.mapView.addAnnotation(trolleyStop)
        }
    }
    
    func updateTrolleys() {
        // TODO: Get Trolley Updates
        
        // Get Trolley Annotations
        let trolleyFilter: ((AnyObject) -> (Bool)) = { (annotation) -> Bool in
            return self.isKindOfClass(TTTrolley.self)
        }
        
        if let trolleyAnnotations = mapView.annotations.filter(trolleyFilter) as? [TTTrolley] {
            
            // TODO: Move Trolley annotations to current locations
            trolleyAnnotations.map {
                trolleyAnnotation -> () in
                
                let annotationView = self.mapView.viewForAnnotation(trolleyAnnotation)
                
                let mapPoint = MKMapPointForCoordinate(trolleyAnnotation.coordinate)
                let zoomFactor = self.mapView.visibleMapRect.size.width / Double(self.mapView.bounds.width)
                let point = CGPoint(x: mapPoint.x/zoomFactor, y: mapPoint.y/zoomFactor)
                
                annotationView.center = point
            }
            
        }

    }
    
    //==========================================================================
    // mark: MKMapViewDelegate
    //==========================================================================
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        
//        // Handle Trolleys
//        if let trolleyAnnotation = annotation as? TTTrolley {
//            let annotationView = MKAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
//            
//            return annotationView
//        }
//        
//        // Handle Stops
//        if let stopAnnotation = annotation as? TTTrolleyStop {
//            let annotationView = MKAnnotationView(annotation: stopAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
//            
//            return annotationView
//        }
//        
//        return nil
//    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        // TODO: Adjust DetailViewController information to show the current selected object (trolley or stop)
    }
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
//        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
//        mapView.setRegion(region, animated: true)
//    }
    
    //==========================================================================
    // mark: Views
    //==========================================================================
    
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