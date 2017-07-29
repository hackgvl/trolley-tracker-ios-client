//
//  Box.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/20/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation

class Box<T> {
    var value: T?
    
    init(value: T) {
        self.value = value 
    }
}