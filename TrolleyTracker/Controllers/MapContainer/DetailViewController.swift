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
    func directionsButtonTapped()
    func walkingTimeButtonTapped()
}

class DetailViewController: UIViewController {

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

    func resetUI() {
        resetLabels()
    }

    func showWalkingLoadingUI() {
        walkingTimeButton.isEnabled = false
        timeLoadingIndicator.startAnimating()
    }

    func show(walkingTime: String) {
        timeLabel.text = walkingTime
        walkingTimeButton.isEnabled = true
        timeLoadingIndicator.stopAnimating()
    }

    func show(distance: String) {
        distanceLabel.text = distance
    }

    func show(titleText: String) {
        titleLabel.text = titleText
    }
    
    //==================================================================
    // MARK: - Dislaying Annotations
    //==================================================================
    
    fileprivate func resetLabels() {
        titleLabel.text = nil
        timeLabel.text = nil
        distanceLabel.text = nil
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @objc fileprivate func handleDirectionsButton(_ sender: UIButton) {
        delegate?.directionsButtonTapped()
    }
    
    @objc fileprivate func handleWalkingTimeButton(_ sender: UIButton) {
        delegate?.walkingTimeButtonTapped()
    }

    //==================================================================
    // MARK: - Views
    //==================================================================

    fileprivate func setupViews() {
        
        view.backgroundColor = UIColor.ttMediumPurple()

        for subview in [
            titleLabel, timeLabel, distanceLabel, walkingTimeButton,
            directionsButton, timeLoadingIndicator] as [UIView] {
                view.addSubview(subview)
        }
        
        let views = ["titleLabel": titleLabel, "timeLabel": timeLabel, "distanceLabel": distanceLabel, "directionsButton": directionsButton, "timeButton": walkingTimeButton, "timeLoading": timeLoadingIndicator] as [String : Any]
        let metrics = ["upperVerticalMargin": 16.0, "lowerVerticalMargin": 8.0, "horizontalMargin": 10.0, "verticalPadding": 8.0, "horizontalPadding": 10.0]

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(upperVerticalMargin)-[titleLabel]-(verticalPadding)-[distanceLabel]-(>=verticalPadding)-[directionsButton]-(lowerVerticalMargin)-|", options: .alignAllLeft, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(horizontalMargin)-[titleLabel]-(>=horizontalMargin)-|", options: [], metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[distanceLabel]-(>=horizontalPadding)-[timeLabel]-(horizontalPadding)-|", options: .alignAllCenterY, metrics: metrics, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[directionsButton]-(>=horizontalPadding)-[timeButton]-(horizontalPadding)-|", options: .alignAllCenterY, metrics: metrics, views: views))

        timeLabel.centerYAnchor == timeLoadingIndicator.centerYAnchor

        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:[timeLoading]-(horizontalMargin)-|", options: [], metrics: metrics, views: views))
    }
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = LS.detailTitleLabel
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    
        return label
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    fileprivate lazy var distanceLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    fileprivate lazy var walkingTimeButton: UIButton = {
        let button = UIButton().useAutolayout()
        button.addTarget(self,
                         action: #selector(handleWalkingTimeButton(_:)),
                         for: .touchUpInside)
        button.setTitle(LS.detailWalkingButton, for: .normal)
        
        return button
    }()
    
    fileprivate lazy var directionsButton: UIButton = {
        let button = UIButton().useAutolayout()
        button.addTarget(self,
                         action: #selector(handleDirectionsButton(_:)),
                         for: .touchUpInside)
        button.setTitle(LS.detailDirectionsButton, for: .normal)
        
        return button
    }()
    
    fileprivate lazy var timeLoadingIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(activityIndicatorStyle: .white).useAutolayout()
        i.stopAnimating()
        i.hidesWhenStopped = true
        
        return i
    }()
}
