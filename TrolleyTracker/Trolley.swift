//
//  Trolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/8/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import Foundation

class Trolley : NSObject {
    
    let name: String
    
    let route: [TrolleyStop]
    
    init(name: String) {
        
        self.name = name
        self.route = [TrolleyStop]()
        
        super.init()
    }
}

