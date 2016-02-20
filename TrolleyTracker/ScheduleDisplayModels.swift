//
//  ScheduleDisplayModels.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

struct ScheduleSection {
    
    let title: String
    let items: [ScheduleItem]
}

struct ScheduleItem {
    
    let title: String
    let routeID: Int
    let times: [String]
}