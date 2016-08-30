//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TrolleyLocationServiceLive: TrolleyLocationService {
    
    static var sharedService = TrolleyLocationServiceLive()
    
    var trolleyObservers = ObserverSet<Trolley>()
    var trolleyPresentObservers = ObserverSet<Bool>()
    
    fileprivate var updateTimer: Timer?
    
    fileprivate var allTrolleys: [Trolley]?
    
    func startTrackingTrolleys() {
        
        let startUpdating = {
            
            // -- Get an initial update on the trolleys
            self.getRunningTrolleys()
            
            // -- Start a timer for updating currently running trolleys (trolleys/running)
            self.updateTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(TrolleyLocationServiceLive.getRunningTrolleys), userInfo: nil, repeats: true)
        }
        
        // If we have already retrieved the Trolley list, just start updating them.
        if allTrolleys != nil {
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
            
            if let trolleys = self.parseTrolleysFromJSON(json as AnyObject?) {
                
                let trolleysPresent = trolleys.count > 0 ? true : false
                
                DispatchQueue.main.async {
                    self.trolleyPresentObservers.notify(trolleysPresent)
                }
                
                for trolley in trolleys {
                    self.updateTrolleysWithTrolley(trolley)
                }
            }
        }
    }
    
    fileprivate func updateTrolleysWithTrolley(_ trolley: Trolley) {
       
        guard var trolleys = self.allTrolleys else { return }
        
        // Find the matching trolley in the allTrolleys array
        if let index = trolleys.index(of: trolley) {
            
            // Create a new trolley with an updated location
            let updatedTrolley = Trolley(trolley: trolleys[index], location: trolley.location)
            
            // Store that back in the array
            trolleys.remove(at: index)
            trolleys.append(updatedTrolley)
            self.allTrolleys = trolleys
            
            // Send a notification with the updated trolley
            DispatchQueue.main.async(execute: {
                self.trolleyObservers.notify(updatedTrolley)
            })
        }
    }
    
    fileprivate func parseTrolleysFromJSON(_ json: AnyObject?) -> [Trolley]? {
        
        if let json: AnyObject = json,
        let trolleyObjects = JSON(json).arrayObject
        {
            return trolleyObjects.map { Trolley(jsonData: $0 as AnyObject) }.filter { $0 != nil }.map { $0! }
        }
        
        return nil
    }
    
}
