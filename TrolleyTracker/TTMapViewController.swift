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

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .Plain, target: self, action:"showSettings")

        let detailViewController = TTDetailViewController();
        view.addSubview(detailView)
        view.addSubview(mapView)

        self.addChildViewController(detailViewController)
        detailView.addSubview(detailViewController.view)
        detailViewController.view.frame = detailView.bounds
        detailViewController.didMoveToParentViewController(self)
        
        let views = ["detailView": detailView, "mapView": mapView]
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[detailView]|", options: nil, metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[mapView]|", options: nil, metrics: nil, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[mapView][detailView(==mapView)]|", options: nil, metrics: nil, views: views))
        
        
        TTTrolleyLocationService.sharedService.trolleyObservers.add(updateTrolley)
        TTTrolleyLocationService.sharedService.startTrackingTrolleys()
        
        loadStops()
        loadTrolleys()
    }
    
    func updateTrolley(trolley: TTTrolley) {
        // Get our Trolley Annotations
        let trolleyAnnotations = mapView.annotations.filter { (annotation) -> Bool in
            return annotation.isKindOfClass(TTTrolley.self)
        }.map {
            aTrolley -> TTTrolley in
            return aTrolley as! TTTrolley
        }
        
        // Check if it exists to avoid a crash pre iOS9
        
        let annotationExists = contains(trolleyAnnotations, trolley)
        
        if annotationExists {
            let trolleyView = mapView.viewForAnnotation(trolley)
            
            if trolleyView != nil {
                println("Move Trolley: \(trolley.identifier)")
                
                let mapPoint = MKMapPointForCoordinate(trolley.coordinate)
                let zoomFactor = self.mapView.visibleMapRect.size.width / Double(self.mapView.bounds.width)
                let point = CGPoint(x: mapPoint.x/zoomFactor, y: mapPoint.y/zoomFactor)
                
                trolleyView.center = point
            }
            else {
                println("No View For Trolley: \(trolley.identifier)")
            }
        }
        else {
            println("Add Trolley: \(trolley.identifier)")
            mapView.addAnnotation(trolley)
        }
    }
    
    func loadStops() {
        // Get Stops
        TTTrolleyStopService.sharedService.loadTrolleyStops { (stops) -> Void in
            // Plot each stop as an annotation on the MapView
            stops.map {
                trolleyStop -> () in
                
                self.mapView.addAnnotation(trolleyStop)
                println("stops \(trolleyStop)")
                
                self.mapView.viewForAnnotation(trolleyStop)
            }
        }
    }
    
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
            annotationView.canShowCallout = true
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
    
    func loadTrolleys() {
        // TODO: Get Trolleys
        let trolleys: [TTTrolley] = []
        
        // Plot each Trolley as an annotation on the MapView
        trolleys.map {
            trolley -> () in
            
            self.mapView.addAnnotation(trolley)
            self.mapView.viewForAnnotation(trolley)
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