//
//  TrolleyDataController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/8/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation

struct TrolleyDataController {
    
    let trolleys: [Trolley]
    
    init() {
        
        let trolley1 = Trolley(name: "Trolley 1")
        let trolley2 = Trolley(name: "Trolley 2")
        
        self.trolleys = [trolley1, trolley2]

    }
    
}
