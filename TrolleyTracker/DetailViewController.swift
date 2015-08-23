//
//  TTDetailViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

protocol TTDetailViewControllerDelegate: class {
    
    func detailViewControllerWantsToShow(controller: TTDetailViewController)
    func detailViewControllerWantsToHide(controller: TTDetailViewController)
}

class TTDetailViewController: UIViewController {

    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    //==================================================================
    // MARK: - API
    //==================================================================
 
    weak var delegate: TTDetailViewControllerDelegate?
    
    var currentlyShowingAnnotation: MKAnnotation?
    
    func showDetailForAnnotation(annotation: MKAnnotation?) {
        
        currentlyShowingAnnotation = annotation
        
        if let trolley = annotation as? Trolley { displayTrolley(trolley) }
        else if let stop = annotation as? TrolleyStop { displayStop(stop) }

        // If we can't show this annotation, we should just request to hide, and set the currentlyShowingAnnotation to nil
        else {
            delegate?.detailViewControllerWantsToHide(self)
            currentlyShowingAnnotation = nil
        }
    }
    
    //==================================================================
    // MARK: - Dislaying Annotations
    //==================================================================
    
    private func displayTrolley(trolley: Trolley) {
        
        titleLabel.text = trolley.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    private func displayStop(stop: TrolleyStop) {
        
        titleLabel.text = stop.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @objc private func handleDirectionsButton(sender: UIButton) {
        
        var location: CLLocation?
        
        if let trolley = currentlyShowingAnnotation as? Trolley { location = trolley.location }
        else if let stop = currentlyShowingAnnotation as? TrolleyStop { location = stop.location }

        if let pointB = location { getDirections(pointB.coordinate) }
    }
    
    @objc private func handleWalkingTimeButton(sender: UIButton) {
        
        
    }
    
    private func getDirections(pointB: CLLocationCoordinate2D) {
        let placeMark = MKPlacemark(coordinate: pointB, addressDictionary: nil)
        let currentLocation = MKMapItem.mapItemForCurrentLocation()
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let mapItem = MKMapItem(placemark: placeMark)
        
        //TODO: Make this the name of the stop or Trolley
        mapItem.name = "Trolley"
        
        MKMapItem.openMapsWithItems([currentLocation, mapItem], launchOptions: launchOptions)
        //mapItem.openInMapsWithLaunchOptions(launchOptions)
    }

    //==================================================================
    // MARK: - Views
    //==================================================================

    private func setupViews() {
        
        view.backgroundColor = UIColor.ttDarkGreen()
        
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(walkingTimeButton)
        view.addSubview(directionsButton)
        
        let views = ["titleLabel": titleLabel, "timeLabel": timeLabel, "distanceLabel": distanceLabel, "directionsButton": directionsButton, "timeButton": walkingTimeButton]
        let metrics = ["verticalMargin": 20.0, "horizontalMargin": 10.0, "verticalPadding": 10.0, "horizontalPadding": 10.0]

        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(verticalMargin)-[titleLabel]-(verticalPadding)-[timeLabel]-(>=verticalPadding)-[directionsButton]-(verticalMargin)-|", options: .AlignAllLeft, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalMargin)-[titleLabel]-(>=horizontalMargin)-|", options: nil, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeLabel]-(horizontalPadding)-[distanceLabel]-(horizontalPadding)-|", options: .AlignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[directionsButton]-(>=horizontalPadding)-[timeButton]-(horizontalPadding)-|", options: .AlignAllCenterY, metrics: metrics, views: views))
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = "Trolly or Stop Name"
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    private lazy var walkingTimeButton: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.addTarget(self, action: "handleWalkingTimeButton:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Get Walking Time", forState: .Normal)
        
        return button
    }()
    
    private lazy var directionsButton: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.addTarget(self, action: "handleDirectionsButton:", forControlEvents: UIControlEvents.TouchUpInside)
        button.setTitle("Directions", forState: .Normal)
        
        return button
    }()
}
