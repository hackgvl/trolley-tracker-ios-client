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

    enum DisplayValue {
        case walkingTime(String)
        case distance(String)
        case title(String)
        case stop(TrolleyStop)
    }

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

    func show(displayValue: DisplayValue) {

        switch displayValue {
        case .distance(let text):
            show(distance: text)
        case .stop(let stop):
            resetUI()
            show(titleText: stop.name)
            show(arrivalTimes: stop.nextTrolleyArrivals)
        case .title(let text):
            resetUI()
            show(titleText: text)
        case .walkingTime(let text):
            show(walkingTime: text)
        }
    }

    private func show(walkingTime: String) {
        timeLabel.text = walkingTime
        walkingTimeButton.isEnabled = true
        timeLoadingIndicator.stopAnimating()
    }

    private func show(distance: String) {
        distanceLabel.text = distance
    }

    private func show(titleText: String) {
        titleLabel.text = titleText
    }

    private func show(arrivalTimes: [TrolleyArrivalTime]) {
        addArrivalTimeLabels(for: arrivalTimes)
    }
    
    //==================================================================
    // MARK: - Dislaying Annotations
    //==================================================================
    
    private func resetLabels() {
        titleLabel.text = nil
        timeLabel.text = nil
        distanceLabel.text = nil
        for view in arrivalTimesStack.subviews {
            view.removeFromSuperview()
        }
    }

    private static var timesFormatter: DateFormatter = {
        let tf = DateFormatter()
        tf.timeStyle = .short
        return tf
    }()

    private func addArrivalTimeLabels(for times: [TrolleyArrivalTime]) {

        if !times.isEmpty {
            let l = UILabel().useAutolayout()
            l.textColor = UIColor.ttLightTextColor()
            l.text = "Estimated Trolley arrival times"
            arrivalTimesStack.addArrangedSubview(l)
        }

        for time in times {

            let stack = UIStackView().useAutolayout()
            stack.axis = .horizontal
            arrivalTimesStack.addArrangedSubview(stack)

            let trolleyLabel = UILabel().useAutolayout()
            trolleyLabel.textColor = UIColor.ttLightTextColor()
            trolleyLabel.text = "\(time.trolleyID)"

            let timeLabel = UILabel().useAutolayout()
            timeLabel.textColor = UIColor.ttLightTextColor()
            timeLabel.text = DetailViewController.timesFormatter.string(from: time.date)

            stack.addArrangedSubview(trolleyLabel)
            stack.addArrangedSubview(timeLabel)
        }
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @objc private func handleDirectionsButton(_ sender: UIButton) {
        delegate?.directionsButtonTapped()
    }
    
    @objc private func handleWalkingTimeButton(_ sender: UIButton) {
        delegate?.walkingTimeButtonTapped()
    }

    //==================================================================
    // MARK: - Views
    //==================================================================

    private func setupViews() {

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

        innerVStack.addArrangedSubview(arrivalTimesStack)

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

    private let arrivalTimesStack: UIStackView = {
        let sv = UIStackView().useAutolayout()
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
