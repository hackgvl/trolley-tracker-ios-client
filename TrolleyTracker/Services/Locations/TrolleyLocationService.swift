//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation


class TrolleyLocationServiceLive: TrolleyLocationService {
    
    static var sharedService = TrolleyLocationServiceLive()
    
    var trolleyObservers = ObserverSet<[Trolley]>()
    var trolleyPresentObservers = ObserverSet<Bool>()
    
    fileprivate var updateTimer: Timer?
    
    fileprivate var allTrolleys: [Trolley] = []
    
    func startTrackingTrolleys() {
        
        let startUpdating = {
            
            // -- Get an initial update on the trolleys
            self.getRunningTrolleys()
            
            // -- Start a timer for updating currently running trolleys (trolleys/running)
            self.updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(TrolleyLocationServiceLive.getRunningTrolleys), userInfo: nil, repeats: true)
        }
        
        // If we have already retrieved the Trolley list, just start updating them.
        guard allTrolleys.isEmpty else {
            startUpdating()
            return
        }
        
        // Otherwise, retrieve list of all trolleys first
        TrolleyRequests.AllTrolleys.responseJSON { (response) -> Void in
            guard let json = response.result.value else { return }
            
            // -- Store the list so we can reference it later
            self.allTrolleys = self.parseTrolleysFromJSON(json as AnyObject?)
            
            startUpdating()
        }
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc fileprivate func getRunningTrolleys() {

        let request = TrolleyRequests.RunningTrolleys
        request.responseJSON{(response) in
            
            guard let json = response.result.value else { return }

            let trolleys = self.parseTrolleysFromJSON(json as AnyObject?)

            let trolleysPresent = !trolleys.isEmpty

            DispatchQueue.main.async {
                self.trolleyPresentObservers.notify(trolleysPresent)
            }

            for trolley in trolleys {
                self.updateTrolleysWithTrolley(trolley)
            }

            let activateUpdatedTrolleys = self.allTrolleys.matching(trolleys)

            DispatchQueue.main.async {
                self.trolleyObservers.notify(activateUpdatedTrolleys)
            }
        }
    }

    fileprivate func updateTrolleysWithTrolley(_ trolley: Trolley) {
       
        var trolleys = self.allTrolleys
        
        // Find the matching trolley in the allTrolleys array
        guard let index = trolleys.index(of: trolley) else { return }

        // Create a new trolley with an updated location
        let updatedTrolley = Trolley(trolley: trolleys[index], location: trolley.location)

        // Store that back in the array
        trolleys.remove(at: index)
        trolleys.append(updatedTrolley)
        allTrolleys = trolleys
    }

    fileprivate func parseTrolleysFromJSON(_ json: AnyObject?) -> [Trolley] {

        guard let json = json,
            let trolleyObjects = JSON(json).arrayObject
            else { return [] }


        return trolleyObjects.flatMap { Trolley(jsonData: $0) }
    }
    
}

extension Array where Element == Trolley {

    func matching(_ otherTrolleys: [Trolley]) -> [Trolley] {
        return filter { otherTrolleys.contains($0) }
    }
}
