//
//  RouteDetailViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 2/20/16.
//  Copyright © 2016 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class RouteDetailViewController: UIViewController, MKMapViewDelegate {

    //==================================================================
    // MARK: - Variables
    //==================================================================
    
    let mapView: MKMapView = {
        let mv = MKMapView().useAutolayout()
        return mv
    }()
    private let routeNameLabel: UILabel = {
        let l = UILabel().useAutolayout()
        l.font = .systemFont(ofSize: 17)
        return l
    }()
    private let dimmingView: UIView = {
        let v = UIView().useAutolayout()
        v.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return v
    }()
    private let activityView: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge).useAutolayout()
        return v
    }()
    
    //==================================================================
    // MARK: - API
    //==================================================================

    func setWaitingUI(visible: Bool) {
        self.setDimmingOverlayVisible(visible, animated: true)
    }

    func display(route: TrolleyRoute) {
        routeNameLabel.text = route.longName
        var overlayRoute = route
        mapView.add(overlayRoute.overlay)
        for stop in route.stops {
            mapView.addAnnotation(stop)
        }
    }

    //==================================================================
    // MARK: - UIViewController Overrides
    //==================================================================

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    //==================================================================
    // MARK: - Implementation
    //==================================================================

    private func setDimmingOverlayVisible(_ visible: Bool, animated: Bool) {
        
        self.dimmingView.isHidden = false
        
        let duration = 0.25
        let changes = { self.dimmingView.alpha = visible ? 1 : 0 }
        let completion: (Bool) -> Void = { finished in
            if !visible { self.dimmingView.isHidden = true }
        }

        guard animated else {
            changes()
            completion(true)
            return
        }

        UIView.animate(withDuration: duration,
                       animations: changes,
                       completion: completion)
    }

    private func setupViews() {

        view.addSubview(mapView)
        mapView.edgeAnchors == edgeAnchors

        let labelBackground = UIView().useAutolayout()
        labelBackground.backgroundColor = UIColor(white: 1, alpha: 0.7)
        view.addSubview(labelBackground)

        view.addSubview(routeNameLabel)
        routeNameLabel.bottomAnchor == bottomLayoutGuide.topAnchor - 12
        routeNameLabel.leadingAnchor == view.leadingAnchor + 12

        labelBackground.edgeAnchors == routeNameLabel.edgeAnchors - 4

        view.addSubview(dimmingView)
        dimmingView.edgeAnchors == view.edgeAnchors

        dimmingView.addSubview(activityView)
        activityView.centerAnchors == dimmingView.centerAnchors
    }
}
