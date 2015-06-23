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
    
    func startTrackingTrolleys() {
        updateTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "getTrolleys", userInfo: nil, repeats: true)
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc private func getTrolleys() {

        Alamofire.request(.GET, "http://104.131.44.166/api/v1/trolly/1/location", parameters: nil)
            .validate(statusCode: 200..<300)
            .responseJSON{(request, response, JSON, error) in
                
                if let JSON: AnyObject = JSON, let trolley = TTTrolley(jsonData: JSON) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.trolleyObservers.notify(trolley)
                    })
                    println("Trolley: \(trolley)")
                }
                
                if (error == nil)
                {
                    println("HTTP Response Body: \(JSON)")
                }
                else
                {
                    println("HTTP HTTP Request failed: \(error)")
                }
        }
    }
}