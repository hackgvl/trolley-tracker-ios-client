//
//  TTMapViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit
import os.log

// TODO: Add tracking button that toggles MKUserTrackingMode like native maps

protocol MapVCDelegate: class {
    func viewAppeared()
    func viewDisappeared()
    func locateMeButtonTapped()
}

class MapViewController: UIViewController {

    typealias ViewControllerDependencies = ApplicationController

    //==================================================================
    // MARK: - Properties
    //==================================================================

    weak var delegate: MapVCDelegate?
    
    let mapView: MKMapView = {
        let v = MKMapView().useAutolayout()
        return v
    }()
    let locateMeButton: UIButton = {
        let b = UIButton().useAutolayout()
        b.setImage(#imageLiteral(resourceName: "LocateMe"), for: .normal)
        b.backgroundColor = UIColor.ttAlternateTintColor()
        b.tintColor = UIColor.ttTintColor()
        b.layer.cornerRadius = 5
        return b
    }()
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.viewAppeared()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        delegate?.viewDisappeared()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    @IBAction func handleNoTrolleyLabelTap(_ sender: UITapGestureRecognizer) {
        // TODO: Transfer to message controller
        tabBarController?.selectedIndex = 1
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    @objc private func handleLocateMeButton(_ sender: UIButton) {
        delegate?.locateMeButtonTapped()
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    fileprivate func setupViews() {

        view.addSubview(mapView)
        mapView.edgeAnchors == view.edgeAnchors

        view.addSubview(locateMeButton)
        locateMeButton.trailingAnchor == view.trailingAnchor - 12
        locateMeButton.bottomAnchor == bottomLayoutGuide.topAnchor - 12
        locateMeButton.widthAnchor == 44
        locateMeButton.heightAnchor == 44

//        noTrolleyLabel.text = "No Trolleys are being tracked right now.\nView the Schedule to see run times and select a route to preview it on the map."
//
//        noTrolleyLabel.backgroundColor = UIColor.ttLightGreen()
//        noTrolleyLabel.textColor = UIColor.white
    }
}
