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
        // TODO: Plot each stop as an annotation on the MapView
    }
    
    func loadTrolleys() {
        // TODO: Plot each Trolley as an annotation on the MapView
    }
    
    func updateTrolleys() {
        // TODO: Move Trolley annotations to current locations
    }
    
    //==========================================================================
    // mark: MKMapViewDelegate
    //==========================================================================
    
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