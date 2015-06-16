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
        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    var title: String! {
        // TODO: Return Trolley Name
        return "Trolley"
    }
    
    var subTitle: String! {
        return "The One"
    }
}

extension TTTrolleyStop: MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    var title: String! {
        // TODO: Return Trolley Name
        return "Trolley"
    }
    
    var subTitle: String! {
        return "The One"
    }
}

// TODO: Add tracking button that toggles MKUserTrackingMode like native maps

class TTMapViewController: UIViewController, MKMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Trolly Tracker"
        
        view.backgroundColor = UIColor.whiteColor()
        
        // TODO: Add DetailViewController as childViewController to detailView container view
        // TODO: Add subviews
        // TODO: Setup AutoLayout
      
      self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Settings", comment: "Settings"), style: .Plain, target: self, action:"showSettings")
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
        // TODO: Move Trolley annotations to current locations
    }
    
    //==========================================================================
    // mark: MKMapViewDelegate
    //==========================================================================
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        // Handle Trolleys
        if let trolleyAnnotation = annotation as? TTTrolley {
            let annotationView = MKAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
            
            return annotationView
        }
        
        // Handle Stops
        if let stopAnnotation = annotation as? TTTrolleyStop {
            let annotationView = MKAnnotationView(annotation: stopAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
            
            return annotationView
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        // TODO: Adjust DetailViewController information to show the current selected object (trolley or stop)
    }
    
    //==========================================================================
    // mark: Views
    //==========================================================================
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        mapView.mapType = MKMapType.Standard
        
        mapView.showsUserLocation = true
        
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
    
    self.navigationController?.pushViewController(settingsViewController, animated: true)
  }
}