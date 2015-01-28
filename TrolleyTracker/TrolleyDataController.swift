//
//  TrolleyDataController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/8/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

protocol TrolleyDataControllerDelegate: class {
    func controller(_:TrolleyDataController, didUpdateTrolleyStop stop: TrolleyStopViewModel)
    func controller(_:TrolleyDataController, didUpdateTrolleyLocation trolley: TrolleyViewModel)
    func controllerDidChangeTrolleyStops(controller: TrolleyDataController)
    func controllerDidUpdateTrolleyList(controller: TrolleyDataController)
}

class TrolleyDataController: NetworkControllerDelegate {
    
    var trolleys: [TrolleyViewModel]
    var updateTimerWalkingTimes: NSTimer?
    var updateTimerTrolleyTimes: NSTimer?
    var updateTimerTrolleyLocations: NSTimer?
    let locationManager = CLLocationManager()
    let networkController = NetworkController()
    weak var delegate: TrolleyDataControllerDelegate?
    
    init(trolleys: [Trolley]) {

        self.trolleys = trolleys.map({TrolleyViewModel(trolley: $0)})
    }
    
    init() {
        trolleys = [TrolleyViewModel]()
        self.networkController.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        updateTrolleyList()
    }
    
    func updateTrolleyList() {
        
        networkController.downloadTrolleyList { (downloadedTrolleys) -> () in
            self.trolleys = downloadedTrolleys.map({TrolleyViewModel(trolley: $0)})
            if let delegate = self.delegate {
                delegate.controllerDidUpdateTrolleyList(self)
            }
            
            for trolley in downloadedTrolleys {
                self.networkController.startTrackingTrolley(trolley)
            }
        }
    }
    
    func startTrackingTrolleys() {
        updateTrolleyDrivingTimes()
        updateTrolleyWalkingTimes()
        updateTrolleyLocations()
        
        self.updateTimerWalkingTimes = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "updateTrolleyWalkingTimes", userInfo: nil, repeats: true)
        self.updateTimerTrolleyTimes = NSTimer.scheduledTimerWithTimeInterval(15.0, target: self, selector: "updateTrolleyDrivingTimes", userInfo: nil, repeats: true)
        self.updateTimerTrolleyLocations = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "updateTrolleyLocations", userInfo: nil, repeats: true)
    }
    
    func stopTrackingTrolleys() {
        self.updateTimerWalkingTimes?.invalidate()
        self.updateTimerTrolleyTimes?.invalidate()
        self.updateTimerTrolleyLocations?.invalidate()
    }
    
    @objc func updateTrolleyWalkingTimes() {
        for trolley in self.trolleys {
            for trolleyStop in trolley.upcomingStops {
                trolleyStop.updateWalkingTime({
                    if let delegate = self.delegate {
                        delegate.controller(self, didUpdateTrolleyStop: trolleyStop)
                    }
                })
            }
        }
    }
    
    @objc func updateTrolleyDrivingTimes() {
        for trolley in self.trolleys {
            for trolleyStop in trolley.upcomingStops {
                trolleyStop.updateTrolleyTime({
                    if let delegate = self.delegate {
                        delegate.controller(self, didUpdateTrolleyStop: trolleyStop)
                    }
                })
            }
        }
    }
    
    @objc func updateTrolleyLocations() {
        
        for (index, trolleyViewModel) in enumerate(trolleys) {
            
            let operation = TrackTrolleyOperation(trolley: trolleyViewModel.model)
            operation.trolleyUpdateHandler = { (trolley: TrolleyViewModel, location: CLLocation) in
                trolley.currentLocation = location
                if let delegate = self.delegate {
                    delegate.controller(self, didUpdateTrolleyLocation: trolleyViewModel)
                }
            }
        }
        
        for trolleyViewModel in trolleys {
            
            
        }
        
        //////////////// Just for simulation /////////////////////////////
        for index in 0..<self.trolleys.count {
            let routePoints = (index == 0) ? DummyData.route1 : DummyData.route1
            let locations = routePoints.map({$0.location})
            if (self.trolleys[index].currentLocation == nil) {
                self.trolleys[index].currentLocation = locations[0]
            }
            else {
                if let currentIndex = find(locations, self.trolleys[index].currentLocation!) {
                    var nextLocation = currentIndex + 1
                    if (nextLocation >= locations.count) { nextLocation = 0 }
                    self.trolleys[index].currentLocation = routePoints[nextLocation].location
                }
            }
        }
        //////////////////////////////////////////////////////////////////
        
        for (index, trolley) in enumerate(self.trolleys) {
            if let delegate = self.delegate {
                delegate.controller(self, didUpdateTrolleyLocation: trolley)
            }
        }
    }
    
    // MARK: NetworkController Delegate
    func controller(_: NetworkController, didUpdateTrolley trolley: Trolley, withLocation location: CLLocation) {
        
    }
    
}
