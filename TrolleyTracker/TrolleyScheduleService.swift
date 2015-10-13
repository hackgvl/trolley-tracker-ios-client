//
//  TrolleyScheduleService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

class TrolleyScheduleService {
    
    typealias LoadScheduleCompletion = (schedule: RouteSchedules) -> Void
    
    static var sharedService = TrolleyScheduleService()
    
    func loadTrolleySchedules(completion: LoadScheduleCompletion) {
        
        // check user defaults
        
        // load from network if necessary
    }
}
