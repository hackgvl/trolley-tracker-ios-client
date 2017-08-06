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
        b.addTarget(self,
                    action: #selector(handleLocateMeButton(_:)),
                    for: .touchUpInside)
        return b
    }()
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================
    
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

    @objc private func handleLocateMeButton(_ sender: UIButton) {
        delegate?.locateMeButtonTapped()
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    private func setupViews() {

        view.addSubview(mapView)
        mapView.edgeAnchors == view.edgeAnchors

        let effect = UIBlurEffect(style: .light)
        let statusBarBlur = UIVisualEffectView(effect: effect).useAutolayout()
        view.addSubview(statusBarBlur)
        statusBarBlur.horizontalAnchors == view.horizontalAnchors
        statusBarBlur.topAnchor == view.topAnchor
        statusBarBlur.bottomAnchor == topLayoutGuide.bottomAnchor

        view.addSubview(locateMeButton)
        locateMeButton.trailingAnchor == view.trailingAnchor - 12
        locateMeButton.bottomAnchor == bottomLayoutGuide.topAnchor - 12
        locateMeButton.widthAnchor == 44
        locateMeButton.heightAnchor == 44
    }
}
