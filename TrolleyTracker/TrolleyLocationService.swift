//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import Alamofire

class TrolleyLocationService {
    
    static var sharedService = TrolleyLocationService()
    
    var trolleyObservers = ObserverSet<Trolley>()
    var trolleyPresentObservers = ObserverSet<Bool>()
    
    private var updateTimer: NSTimer?
    
    private var allTrolleys: [Trolley]?
    
    func startTrackingTrolleys() {
        
        // Retrieve list of all trolleys 
        TrolleyRequests.AllTrolleys.responseJSON { (request, response, result) -> Void in

            guard let json = result.value else { return }
            
            // -- Store the list so we can reference it later
            self.allTrolleys = self.parseTrolleysFromJSON(json)
            
            // -- Get an initial update on the trolleys
            self.getRunningTrolleys()
            
            // -- Start a timer for updating currently running trolleys (trolleys/running)
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getRunningTrolleys", userInfo: nil, repeats: true)
        }
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc private func getRunningTrolleys() {

        let request = EnvironmentVariables.currentBuildConfiguration() == .Test ? TrolleyRequests.AllTrolleys : TrolleyRequests.RunningTrolleys
        request.responseJSON{(request, response, result) in
            
            guard let json = result.value else { return }
            
            if let trolleys = self.parseTrolleysFromJSON(json) {
                
                let trolleysPresent = trolleys.count > 0 ? true : false
                dispatch_async(dispatch_get_main_queue()) {
                    self.trolleyPresentObservers.notify(trolleysPresent)
                }
                
                for trolley in trolleys {
                    self.updateTrolleysWithTrolley(trolley)
                }
            }
        }
    }
    
    private func updateTrolleysWithTrolley(trolley: Trolley) {
       
        guard var trolleys = self.allTrolleys else { return }
        
        // Find the matching trolley in the allTrolleys array
        if let index = trolleys.indexOf(trolley) {
            
            // Create a new trolley with an updated location
            let updatedTrolley = Trolley(trolley: trolleys[index], location: trolley.location)
            
            // Store that back in the array
            trolleys.removeAtIndex(index)
            trolleys.append(updatedTrolley)
            self.allTrolleys = trolleys
            
            // Send a notification with the updated trolley
            dispatch_async(dispatch_get_main_queue(), {
                self.trolleyObservers.notify(updatedTrolley)
            })
        }
    }
    
    private func parseTrolleysFromJSON(json: AnyObject?) -> [Trolley]? {
        
        if let json: AnyObject = json,
        trolleyObjects = JSON(json).arrayObject
        {
            return trolleyObjects.map { Trolley(jsonData: $0) }.filter { $0 != nil }.map { $0! }
        }
        
        return nil
    }
    
}