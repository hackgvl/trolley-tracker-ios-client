//
//  TTDetailViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class TTDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(shareButton)
        view.addSubview(directionsButton)
        directionsButton.addSubview(directionsButtonLabel)
        
        let views = ["title": titleLabel, "time": timeLabel, "distance": distanceLabel, "share": shareButton, "directions": directionsButton, "buttonLabel": directionsButtonLabel]
        
        let metrics = ["bottomMargin": 20.0, "sideMargin": 10.0]
        
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]-(bottomMargin)-[time]-(>=bottomMargin)-[directions]-(bottomMargin)-|", options: nil, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]-(bottomMargin)-[distance]-(>=bottomMargin)-[directions]-(bottomMargin)-|", options: nil, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[share(44)]-(bottomMargin)-[distance]-(>=bottomMargin)-[directions]-(bottomMargin)-|", options: nil, metrics: metrics, views: views))
        
        NSLayoutConstraint(item: shareButton, attribute: .Top, relatedBy: .Equal, toItem: titleLabel, attribute: .Top, multiplier: 1.0, constant: 0.0).active = true
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(sideMargin)-[title]-[share(44)]-(sideMargin)-|", options: nil, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(sideMargin)-[time]-(sideMargin)-[distance]", options: nil, metrics: metrics, views: views))
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(sideMargin)-[directions]-(sideMargin)-|", options: nil, metrics: metrics, views: views))
        
        
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[directions]-(<=1)-[buttonLabel]", options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[directions]-(<=1)-[buttonLabel]", options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: nil, views: views))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.blackColor()
        label.text = "Trolly or Stop Name"
    
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.blackColor()
        label.text = "7 Minutes"
        
        return label
    }()
    
    lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.blackColor()
        label.text = "7 Miles"
        
        return label
    }()
    
    lazy var shareButton: UIView = {
        let placeHolderForView = UIView(frame: CGRectZero)
        placeHolderForView.setTranslatesAutoresizingMaskIntoConstraints(false)
        placeHolderForView.backgroundColor = UIColor.redColor()
        
        return placeHolderForView
    }()
    
    lazy var directionsButton: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: "handleDirectionsButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    lazy var directionsButtonLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(18.0)
        label.text = "Directions"
        
        return label
    }()
    
    func handleDirectionsButton(sender: UIButton) {
        NSLog("Directions Button Clicked...")
        let pointB = TTTrolleyStopService().dummyTrolleyStops[0]
        getDirections(pointB.location.coordinate)
    }

    func getDirections(pointB: CLLocationCoordinate2D) {
        let placeMark = MKPlacemark(coordinate: pointB, addressDictionary: nil)
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let mapItem = MKMapItem(placemark: placeMark)
        
        //TODO: Make this the name of the stop or Trolley 
        mapItem.name = "Trolley"
        
        MKMapItem.openMapsWithItems([currentLocation, mapItem], launchOptions: launchOptions)
        //mapItem.openInMapsWithLaunchOptions(launchOptions)
    }
}
