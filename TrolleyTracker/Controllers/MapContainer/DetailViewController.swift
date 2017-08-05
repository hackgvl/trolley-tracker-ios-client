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

    override func loadView() {
        self.view = rootStack
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

        let backgroundView = UIView().useAutolayout()
        backgroundView.backgroundColor = .ttMediumPurple()
        view.addSubview(backgroundView)
        backgroundView.edgeAnchors == view.edgeAnchors

        let vMargin: CGFloat = 14
        let hMargin: CGFloat = 16
        let vSpacing: CGFloat = 6

        let innerVStack = UIStackView().useAutolayout()
        innerVStack.axis = .vertical
        innerVStack.spacing = vSpacing

        let outerHStack = UIStackView().useAutolayout()
        outerHStack.axis = .horizontal
        rootStack.addArrangedSubview(outerHStack)
        outerHStack.addArrangedSubview(.spacerView(width: hMargin))
        outerHStack.addArrangedSubview(innerVStack)
        outerHStack.addArrangedSubview(.spacerView(width: hMargin))

        innerVStack.addArrangedSubview(.spacerView(height: vMargin))
        innerVStack.addArrangedSubview(titleLabel)

        let secondaryLabelStack = UIStackView().useAutolayout()
        secondaryLabelStack.axis = .horizontal
        innerVStack.addArrangedSubview(secondaryLabelStack)
        secondaryLabelStack.addArrangedSubview(distanceLabel)
        secondaryLabelStack.addArrangedSubview(.flexibleView())
        secondaryLabelStack.addArrangedSubview(timeLabel)

        innerVStack.addArrangedSubview(.spacerView(height: 10))

        let buttonsStack = UIStackView().useAutolayout()
        buttonsStack.axis = .horizontal
        innerVStack.addArrangedSubview(buttonsStack)
        buttonsStack.addArrangedSubview(directionsButton)
        buttonsStack.addArrangedSubview(.flexibleView())
        buttonsStack.addArrangedSubview(walkingTimeButton)

        innerVStack.addArrangedSubview(.spacerView(height: vMargin))
    }

    private let rootStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = LS.detailTitleLabel
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
    
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    private let distanceLabel: UILabel = {
        let label = UILabel().useAutolayout()
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textColor = UIColor.ttLightTextColor()
        label.text = ""
        
        return label
    }()
    
    private lazy var walkingTimeButton: UIButton = {
        let button = SolidButton().useAutolayout()
        button.addTarget(self,
                         action: #selector(handleWalkingTimeButton(_:)),
                         for: .touchUpInside)
        button.setTitle(LS.detailWalkingButton, for: .normal)
        
        return button
    }()
    
    private lazy var directionsButton: UIButton = {
        let button = SolidButton().useAutolayout()
        button.addTarget(self,
                         action: #selector(handleDirectionsButton(_:)),
                         for: .touchUpInside)
        button.setTitle(LS.detailDirectionsButton, for: .normal)
        
        return button
    }()
    
    private let timeLoadingIndicator: UIActivityIndicatorView = {
        let i = UIActivityIndicatorView(activityIndicatorStyle: .white).useAutolayout()
        i.stopAnimating()
        i.hidesWhenStopped = true
        
        return i
    }()
}
