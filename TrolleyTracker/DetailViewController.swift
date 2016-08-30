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
    
    func detailViewControllerWantsToShow(_ controller: DetailViewController)
    func detailViewControllerWantsToHide(_ controller: DetailViewController)
}

class DetailViewController: UIViewController {
    
    //==================================================================
    // MARK: - Properties
    //==================================================================

    fileprivate static var distanceFormatter: MKDistanceFormatter {
        let formatter = MKDistanceFormatter()
        formatter.units = MKDistanceFormatterUnits.imperial
        formatter.unitStyle = MKDistanceFormatterUnitStyle.default
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
    
    func showDetailForAnnotation(_ annotation: MKAnnotation?, withUserLocation userLocation: MKUserLocation?) {
        
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
    
    fileprivate func displayTrolley(_ trolley: Trolley) {
        
        titleLabel.text = trolley.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    fileprivate func displayStop(_ stop: TrolleyStop) {
        
        titleLabel.text = stop.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    fileprivate func showDistance() {
        
        if let pointA = currentUserLocation?.location,
        let detailItemCoordinate = currentlyShowingAnnotation?.coordinate
        {
            let pointB = CLLocation(latitude: detailItemCoordinate.latitude, longitude: detailItemCoordinate.longitude)
            let distance = pointA.distance(from: pointB)
            
            distanceLabel.text = DetailViewController.distanceFormatter.string(fromDistance: distance)
        }
    }
    
    fileprivate func resetLabels() {
        titleLabel.text = nil
        timeLabel.text = nil
        distanceLabel.text = nil
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @objc fileprivate func handleDirectionsButton(_ sender: UIButton) {
        
        var location: CLLocation?
        
        if let trolley = currentlyShowingAnnotation as? Trolley { location = trolley.location }
        else if let stop = currentlyShowingAnnotation as? TrolleyStop { location = stop.location }

        if let pointB = location { getDirections(pointB.coordinate) }
    }
    
    @objc fileprivate func handleWalkingTimeButton(_ sender: UIButton) {
        getWalkingTime(false)
    }
    
    fileprivate func getWalkingTime(_ cacheResultsOnly: Bool) {
        
        guard let annotation = currentlyShowingAnnotation else { return }
        guard let userLocation = currentUserLocation?.location else { return }
        
        let source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate, addressDictionary: nil))
        
        walkingTimeButton.isEnabled = false
        timeLoadingIndicator.startAnimating()
        
        TimeAndDistanceService.walkingTravelTimeBetweenPoints(source, pointB: destination, cacheResultsOnly: cacheResultsOnly) { (rawTime, formattedTime) -> Void in
            DispatchQueue.main.async(execute: {
                // Set time label with directions result
                self.timeLabel.text = formattedTime
                self.walkingTimeButton.isEnabled = true
                self.timeLoadingIndicator.stopAnimating()
            })
        }
    }
    
    fileprivate func getDirections(_ pointB: CLLocationCoordinate2D) {
        let placeMark = MKPlacemark(coordinate: pointB, addressDictionary: nil)
        let currentLocation = MKMapItem.forCurrentLocation()
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        let mapItem = MKMapItem(placemark: placeMark)
        
        //TODO: Make this the name of the stop or Trolley
        mapItem.name = "Trolley"
        
        MKMapItem.openMaps(with: [currentLocation, mapItem], launchOptions: launchOptions)
        //mapItem.openInMapsWithLaunchOptions(launchOptions)
    }

    //==================================================================
    // MARK: - Views
    //==================================================================

    fileprivate func setupViews() {
        
        view.backgroundColor = UIColor.ttMediumPurple()
        
        view.addSubview(titleLabel)
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(walkingTimeButton)
        view.addSubview(directionsButton)
        view.addSubview(timeLoadingIndicator)
        
        let views = ["titleLabel": titleLabel, "timeLabel": timeLabel, "distanceLabel": distanceLabel, "directionsButton": directionsButton, "timeButton": walkingTimeButton, "timeLoading": timeLoadingIndicator] as [String : Any]
        let metrics = ["upperVerticalMargin": 16.0, "lowerVerticalMargin": 8.0, "horizontalMargin": 10.0, "verticalPadding": 8.0, "horizontalPadding": 10.0]

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(upperVerticalMargin)-[titleLabel]-(verticalPadding)-[distanceLabel]-(>=verticalPadding)-[directionsButton]-(lowerVerticalMargin)-|", options: .alignAllLeft, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalMargin)-[titleLabel]-(>=horizontalMargin)-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[distanceLabel]-(>=horizontalPadding)-[timeLabel]-(horizontalPadding)-|", options: .alignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[directionsButton]-(>=horizontalPadding)-[timeButton]-(horizontalPadding)-|", options: .alignAllCenterY, metrics: metrics, views: views))
        
        NSLayoutConstraint.activate([NSLayoutConstraint(item: timeLabel, attribute: .centerY, relatedBy: .equal, toItem: timeLoadingIndicator, attribute: .centerY, multiplier: 1.0, constant: 0.0)])
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[timeLoading]-(horizontalMargin)-|", options: [], metrics: metrics, views: views))
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = "Trolly or Stop Name"
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    fileprivate lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    fileprivate lazy var walkingTimeButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(DetailViewController.handleWalkingTimeButton(_:)), for: UIControlEvents.touchUpInside)
        button.setTitle("Get Walking Time", for: UIControlState())
        
        return button
    }()
    
    fileprivate lazy var directionsButton: UIButton = {
        let button = UIButton(frame: CGRect.zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(DetailViewController.handleDirectionsButton(_:)), for: UIControlEvents.touchUpInside)
        button.setTitle("Directions", for: UIControlState())
        
        return button
    }()
    
    fileprivate lazy var timeLoadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
}
