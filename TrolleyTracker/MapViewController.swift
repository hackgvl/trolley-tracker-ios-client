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

class MapViewController: UIViewController, MKMapViewDelegate, DetailViewControllerDelegate, StoryboardInjectable {

    typealias ViewControllerDependencies = ApplicationController

    //==================================================================
    // MARK: - Properties
    //==================================================================

    private let appController: ApplicationController

    var detailViewController: DetailViewController!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var locateMeButton: UIButton!
    @IBOutlet var noTrolleyLabel: UILabel!
    
    @IBOutlet var noTrolleyLabelTapGesture: UITapGestureRecognizer!

    @IBOutlet var detailViewHiddenConstraint: NSLayoutConstraint!
    
    @IBOutlet var noTrolleyHiddenConstraint: NSLayoutConstraint!
    @IBOutlet var noTrolleyVisibleConstraint: NSLayoutConstraint!
    
    fileprivate let locationManager = CLLocationManager()
    
    fileprivate let mapViewDelegate = TrolleyMapViewDelegate()
    
    //==================================================================
    // MARK: - Lifecycle
    //==================================================================

    required init?(coder aDecoder: NSCoder) {
        self.appController = MapViewController.getDependencies()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()

        mapViewDelegate.annotationSelectionAction = { [unowned self] view in
            self.detailViewController.showDetailForAnnotation(view.annotation, withUserLocation: self.mapView.userLocation)
        }
        mapViewDelegate.annotationDeselectionAction = { [unowned self] view in
            self.detailViewController.showDetailForAnnotation(nil, withUserLocation: nil)
        }
        mapView.delegate = mapViewDelegate
        
        let _ = appController.trolleyLocationService.trolleyPresentObservers.add(updateTrolleyPresent)
        let _ = appController.trolleyLocationService.trolleyObservers.add(updateTrolley)
        
        locationManager.requestWhenInUseAuthorization()
        
        mapView.setRegionToDowntownGreenville()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        loadRoutes()
        appController.trolleyLocationService.startTrackingTrolleys()
        startRefreshTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        appController.trolleyLocationService.stopTrackingTrolley()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        stopRefreshTimer()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailController = segue.destination as? DetailViewController {
            self.detailViewController = detailController
            detailController.delegate = self 
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    //==================================================================
    // MARK: - Actions
    //==================================================================
    
    fileprivate func updateTrolley(_ trolley: Trolley) {
        mapView.addOrUpdateTrolley(trolley)
    }
    
    fileprivate func updateTrolleyPresent(_ present: Bool) {
        setNoTrolleyMessageVisible(!present, animated: true)
    }
    
    fileprivate func loadRoutes() {
        appController.trolleyRouteService.loadTrolleyRoutes { routes in
            self.mapView.replaceCurrentRoutes(with: routes)
        }
    }
    
    fileprivate func setDetailViewVisible(_ visible: Bool, animated: Bool) {
        detailViewHiddenConstraint.isActive = !visible
        updateLayout(animated: true)
    }
    
    fileprivate func setNoTrolleyMessageVisible(_ visible: Bool, animated: Bool) {
        noTrolleyVisibleConstraint.isActive = visible
        updateLayout(animated: true)
    }

    fileprivate func updateLayout(animated: Bool) {
        let updateAction = { self.view.layoutIfNeeded() }
        if animated { UIView.animate(withDuration: 0.25, animations: updateAction) }
        else { updateAction() }
    }
    
    @IBAction func handleNoTrolleyLabelTap(_ sender: UITapGestureRecognizer) {
        tabBarController?.selectedIndex = 1
    }

    //==================================================================
    // MARK: - Refresh Timer
    //==================================================================

    private var updateTimer: Timer?

    private func startRefreshTimer() {
        updateTimer = Timer.scheduledTimer(timeInterval: 60,
                                           target: self,
                                           selector: #selector(handleRefreshTimerFired),
                                           userInfo: nil, repeats: false)
    }

    private func stopRefreshTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    @objc private func handleRefreshTimerFired() {
        if #available(iOS 10.0, *) {
            os_log("Refresh timer fired, loading routes")
        }
        loadRoutes()
    }
    
    //==================================================================
    // MARK: - TTDetailViewControllerDelegate
    //==================================================================
    
    func detailViewControllerWantsToShow(_ controller: DetailViewController) {
        setDetailViewVisible(true, animated: true)
    }
    
    func detailViewControllerWantsToHide(_ controller: DetailViewController) {
        setDetailViewVisible(false, animated: true)
    }
    
    //==========================================================================
    // MARK: - Actions
    //==========================================================================
    
    @IBAction func handleLocateMeButton(_ sender: UIButton) {
        mapView.centerOnUserPossible(presentationContext: self)
    }
    
    //==========================================================================
    // MARK: - Views
    //==========================================================================
    
    fileprivate func setupViews() {
        
        title = "Map"
        noTrolleyLabel.text = "No Trolleys are being tracked right now.\nView the Schedule to see run times and select a route to preview it on the map."
        
        view.backgroundColor = UIColor.white
        
        noTrolleyLabel.backgroundColor = UIColor.ttLightGreen()
        noTrolleyLabel.textColor = UIColor.white
        
        locateMeButton.backgroundColor = UIColor.ttAlternateTintColor()
        locateMeButton.tintColor = UIColor.ttTintColor()
        locateMeButton.layer.cornerRadius = 5

        noTrolleyHiddenConstraint.isActive = false
        noTrolleyHiddenConstraint.constant = 0

        setNoTrolleyMessageVisible(false, animated: false)
        setDetailViewVisible(false, animated: false)
    }
}
