//
//  TTDetailViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

protocol DetailViewControllerDelegate: class {
    
    func detailViewControllerWantsToShow(controller: DetailViewController)
    func detailViewControllerWantsToHide(controller: DetailViewController)
}

class DetailViewController: UIViewController {
    
    //==================================================================
    // MARK: - Properties
    //==================================================================

    private static var distanceFormatter: MKDistanceFormatter {
        var formatter = MKDistanceFormatter()
        formatter.units = MKDistanceFormatterUnits.Imperial
        formatter.unitStyle = MKDistanceFormatterUnitStyle.Default
        return formatter
    }
    
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
 
    weak var delegate: DetailViewControllerDelegate?
    
    var currentlyShowingAnnotation: MKAnnotation?
    var currentUserLocation: MKUserLocation?
    
    func showDetailForAnnotation(annotation: MKAnnotation?, withUserLocation userLocation: MKUserLocation?) {
        
        resetLabels()
        
        var annotationToDisplay = annotation
        
        if let trolley = annotationToDisplay as? Trolley { displayTrolley(trolley) }
        else if let stop = annotationToDisplay as? TrolleyStop { displayStop(stop) }

        // If we can't show this annotation, we should just request to hide, and set the currentlyShowingAnnotation to nil
        else {
            delegate?.detailViewControllerWantsToHide(self)
            annotationToDisplay = nil
        }
        
        currentUserLocation = userLocation
        currentlyShowingAnnotation = annotationToDisplay
        
        showDistance()
        getWalkingTime(true)
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
    
    private func showDistance() {
        
        if let pointA = currentUserLocation?.location,
        detailItemCoordinate = currentlyShowingAnnotation?.coordinate
        {
            let pointB = CLLocation(latitude: detailItemCoordinate.latitude, longitude: detailItemCoordinate.longitude)
            let distance = pointA.distanceFromLocation(pointB)
            
            distanceLabel.text = DetailViewController.distanceFormatter.stringFromDistance(distance)
        }
    }
    
    private func resetLabels() {
        titleLabel.text = nil
        timeLabel.text = nil
        distanceLabel.text = nil
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
        getWalkingTime(false)
    }
    
    private func getWalkingTime(cacheResultsOnly: Bool) {
        
        if currentlyShowingAnnotation == nil { return }
        if currentUserLocation?.location == nil { return }
        let annotation = currentlyShowingAnnotation!
        let userLocation = currentUserLocation!.location
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
        
        walkingTimeButton.enabled = false
        timeLoadingIndicator.startAnimating()
        
        TimeAndDistanceService.walkingTravelTimeBetweenPoints(source, pointB: destination, cacheResultsOnly: cacheResultsOnly) { (rawTime, formattedTime) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                // Set time label with directions result
                self.timeLabel.text = formattedTime
                self.walkingTimeButton.enabled = true
                self.timeLoadingIndicator.stopAnimating()
            })
        }
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
        view.addSubview(timeLoadingIndicator)
        
        let views = ["titleLabel": titleLabel, "timeLabel": timeLabel, "distanceLabel": distanceLabel, "directionsButton": directionsButton, "timeButton": walkingTimeButton, "timeLoading": timeLoadingIndicator]
        let metrics = ["verticalMargin": 20.0, "horizontalMargin": 10.0, "verticalPadding": 10.0, "horizontalPadding": 10.0]

        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(verticalMargin)-[titleLabel]-(verticalPadding)-[distanceLabel]-(>=verticalPadding)-[directionsButton]-(verticalMargin)-|", options: .AlignAllLeft, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(horizontalMargin)-[titleLabel]-(>=horizontalMargin)-|", options: nil, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[distanceLabel]-(>=horizontalPadding)-[timeLabel]-(horizontalPadding)-|", options: .AlignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[directionsButton]-(>=horizontalPadding)-[timeButton]-(horizontalPadding)-|", options: .AlignAllCenterY, metrics: metrics, views: views))
        
        NSLayoutConstraint.activateConstraints([NSLayoutConstraint(item: timeLabel, attribute: .CenterY, relatedBy: .Equal, toItem: timeLoadingIndicator, attribute: .CenterY, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[timeLoading]-(horizontalMargin)-|", options: nil, metrics: metrics, views: views))
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(20.0)
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
        label.font = UIFont.boldSystemFontOfSize(20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(20.0)
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
    
    private lazy var timeLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indicator.setTranslatesAutoresizingMaskIntoConstraints(false)
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
}
