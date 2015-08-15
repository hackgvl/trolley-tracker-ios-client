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
        
        if let trolley = annotation as? TTTrolley { displayTrolley(trolley) }
        else if let stop = annotation as? TTTrolleyStop { displayStop(stop) }

        // If we can't show this annotation, we should just request to hide, and set the currentlyShowingAnnotation to nil
        else {
            delegate?.detailViewControllerWantsToHide(self)
            currentlyShowingAnnotation = nil
        }
    }
    
    //==================================================================
    // MARK: - Dislaying Annotations
    //==================================================================
    
    private func displayTrolley(trolley: TTTrolley) {
        
        titleLabel.text = trolley.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    private func displayStop(stop: TTTrolleyStop) {
        
        titleLabel.text = stop.name
        delegate?.detailViewControllerWantsToShow(self)
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @objc private func handleDirectionsButton(sender: UIButton) {
        
        var location: CLLocation?
        
        if let trolley = currentlyShowingAnnotation as? TTTrolley { location = trolley.location }
        else if let stop = currentlyShowingAnnotation as? TTTrolleyStop { location = stop.location }

        if let pointB = location { getDirections(pointB.coordinate) }
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.blackColor()
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
        label.textColor = UIColor.blackColor()
        label.text = "7 Minutes"
        
        return label
    }()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.font = UIFont.boldSystemFontOfSize(30.0)
        label.textColor = UIColor.blackColor()
        label.text = "7 Miles"
        
        return label
    }()
    
    private lazy var shareButton: UIView = {
        let placeHolderForView = UIView(frame: CGRectZero)
        placeHolderForView.setTranslatesAutoresizingMaskIntoConstraints(false)
        placeHolderForView.backgroundColor = UIColor.redColor()
        
        return placeHolderForView
    }()
    
    private lazy var directionsButton: UIButton = {
        let button = UIButton(frame: CGRectZero)
        button.setTranslatesAutoresizingMaskIntoConstraints(false)
        button.backgroundColor = UIColor.lightGrayColor()
        button.addTarget(self, action: "handleDirectionsButton:", forControlEvents: UIControlEvents.TouchUpInside)
        
        return button
    }()
    
    private lazy var directionsButtonLabel: UILabel = {
        let label = UILabel(frame: CGRectZero)
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textColor = UIColor.blackColor()
        label.font = UIFont.boldSystemFontOfSize(18.0)
        label.text = "Directions"
        
        return label
    }()
}
