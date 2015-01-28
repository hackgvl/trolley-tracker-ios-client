//
//  TrackTrolleyOperation.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/20/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import CoreLocation

typealias TrolleyDidUpdateHandler = (trolley: TrolleyViewModel, location: CLLocation) -> ()

class TrackTrolleyOperation: NSOperation {

    var trolleyUpdateHandler: TrolleyDidUpdateHandler?
    let trolley: Trolley

    override var asynchronous: Bool {
        get {
            return true
        }
    }
    
    var _executing: Bool = false
    override var executing: Bool {
        get {
            return _executing
        }
        set(newValue) {
            willChangeValueForKey("executing")
            _executing = newValue
            didChangeValueForKey("executing")
        }
    }
    
    init(trolley: Trolley) {
        self.trolley = trolley
    }
    
    override func start() {
        executing = true
        
        
    }
    
}
