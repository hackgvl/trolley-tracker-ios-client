//
//  UIColor+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/20/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var routeColors: [UIColor] {
        get {
            return [
                UIColor.redColor(),
                UIColor.greenColor(),
                UIColor.blueColor(),
                UIColor.purpleColor(),
            ]
        }
    }
    
    class func routeColorForIndex(index: Int) -> UIColor {
        return routeColors[index % routeColors.count]
    }
}
