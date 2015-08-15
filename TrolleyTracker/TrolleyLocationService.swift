//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import Alamofire

class TTTrolleyLocationService {
    
    static var sharedService = TTTrolleyLocationService()
    
    var trolleyObservers = ObserverSet<TTTrolley>()
    
    private var updateTimer: NSTimer?
    
    private var allTrolleys: [TTTrolley]?
    
    func startTrackingTrolleys() {
        
        // Retrieve list of all trolleys 
        TrolleyRequests.AllTrolleys.responseJSON { (request, response, json, error) -> Void in
            
            // -- Store the list so we can reference it later
            self.allTrolleys = self.parseTrolleysFromJSON(json)
            
            // -- Start a timer for updating currently running trolleys (trolleys/running)
            self.updateTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getRunningTrolleys", userInfo: nil, repeats: true)
        }
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc private func getRunningTrolleys() {

        TrolleyRequests.RunningTrolleys.responseJSON{(request, response, json, error) in
            
            if let trolleys = self.parseTrolleysFromJSON(json) {
                for trolley in trolleys {
                    self.updateTrolleysWithTrolley(trolley)
                }
            }
        }
    }
    
    private func updateTrolleysWithTrolley(trolley: TTTrolley) {
       
        if self.allTrolleys == nil { return }
        var trolleys = self.allTrolleys!
        
        // Find the matching trolley in the allTrolleys array
        if let index = find(trolleys, trolley) {
            
            // Create a new trolley with an updated location
            let updatedTrolley = TTTrolley(trolley: trolleys[index], location: trolley.location)
            
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
    
    private func parseTrolleysFromJSON(json: AnyObject?) -> [TTTrolley]? {
        
        if let json: AnyObject = json,
        trolleyObjects = JSON(json).arrayObject
        {
            var trolleys: [TTTrolley?] = trolleyObjects.map({ TTTrolley(jsonData: $0) })
            var returnTrolleys = [TTTrolley]()
            for trolley in trolleys {
                if let trolley = trolley { returnTrolleys.append(trolley) }
            }
            
            return returnTrolleys
        }
        
        return nil
    }
    
}