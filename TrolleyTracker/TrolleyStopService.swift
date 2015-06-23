//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation

class TTTrolleyStopService {
    
    typealias LoadTrolleyStopCompletion = (stops: [TTTrolleyStop]) -> Void
 
    static var sharedService = TTTrolleyStopService()
    
    func loadTrolleyStops(completion: LoadTrolleyStopCompletion) {
        
    }
}