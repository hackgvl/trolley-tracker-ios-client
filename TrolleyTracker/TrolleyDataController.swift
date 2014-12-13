//
//  TrolleyDataController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/8/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation

struct TrolleyDataController {
    
    let trolleys: [TrolleyViewModel]
    
    init(trolleys: [Trolley]) {

        self.trolleys = trolleys.map({TrolleyViewModel(trolley: $0)})
    }
    
    init() {
        let trolley1 = Trolley(name: "Trolley 1", route: [])
        let trolley2 = Trolley(name: "Trolley 2", route: [])
        let models = [trolley1, trolley2]
        
        self.trolleys = models.map({TrolleyViewModel(trolley: $0)})
    }
    
}
