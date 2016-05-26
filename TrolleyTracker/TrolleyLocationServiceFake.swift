//
//  TrolleyLocationServiceFake.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/28/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TrolleyLocationServiceFake: TrolleyLocationService {
    
    private var updateTimer: NSTimer?
    private var lastUpdateIndex: Int = 0
    private var lastUpdateIndex1: Int = 2
    
    var trolleyObservers = ObserverSet<Trolley>()
    var trolleyPresentObservers = ObserverSet<Bool>()
    
    func startTrackingTrolleys() {
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TrolleyLocationServiceFake.updateTrolleys), userInfo: nil, repeats: true)
        updateTrolleys()
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc private func updateTrolleys() {
        
        trolleyPresentObservers.notify(true)
//        trolleyObservers.notify(Trolley(identifier: 1, location: locations[nextLocationIndex()], name: "Trolley 1", number: 1))
//        trolleyObservers.notify(Trolley(identifier: 2, location: locations[nextLocationIndex()], name: "Trolley 2", number: 2))
        trolleyObservers.notify(Trolley(identifier: 1, location: locations[0], name: "Trolley 1", number: 1))
        trolleyObservers.notify(Trolley(identifier: 2, location: locations[3], name: "Trolley 2", number: 2))
    }
    
    private func nextLocationIndex() -> Int {
        let currentIndex = lastUpdateIndex
        lastUpdateIndex = lastUpdateIndex >= (locations.count - 1) ? 0 : lastUpdateIndex + 1
        return currentIndex
    }
    
    private func nextLocationIndex1() -> Int {
        let currentIndex = lastUpdateIndex1
        lastUpdateIndex1 = lastUpdateIndex1 >= (locations.count - 1) ? 0 : lastUpdateIndex1 + 1
        return currentIndex
    }
    
    var locations: [CLLocation] = [
        CLLocation(latitude: 34.8595832, longitude: -82.3952439),
        CLLocation(latitude: 34.8503157, longitude: -82.3992308),
        CLLocation(latitude: 34.8466131, longitude: -82.400934),
        CLLocation(latitude: 34.8416466, longitude: -82.407466)
    ]
}