//
//  UIColor+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/20/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func ttTintColor() -> UIColor { return UIColor.whiteColor() }
    
    class func ttDarkGreen() -> UIColor { return UIColor(red:0.031, green:0.439, blue:0.298, alpha:1) }
    class func ttYellowGreen() -> UIColor { return UIColor(red:0.658, green:0.69, blue:0.133, alpha:1) }
    class func ttRed() -> UIColor { return UIColor(red:0.78, green:0.18, blue:0.121, alpha:1) }
    
    class func ttRouteColorGreen() -> UIColor { return UIColor(red:0.78, green:0.18, blue:0.121, alpha:1) }
    class func ttRouteColorOrange() -> UIColor { return UIColor(red:0.909, green:0.564, blue:0.047, alpha:1) }
    class func ttRouteColorRed() -> UIColor { return UIColor(red:1, green:0, blue:0, alpha:1) }
    class func ttRouteColorPurple() -> UIColor { return UIColor(red:0.396, green:0.047, blue:0.909, alpha:1) }
    class func ttRouteColorBlue() -> UIColor { return UIColor(red:0.05, green:0.721, blue:1, alpha:1) }
    
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
    
    class var routeColors: [UIColor] {
        get {
            
            let colors = [
                UIColor.ttRouteColorGreen(),
                UIColor.ttRouteColorPurple(),
                UIColor.ttRouteColorBlue(),
                UIColor.ttRouteColorOrange(),
                UIColor.ttRouteColorRed()
            ]
            
            return colors.map { $0.colorWithAlphaComponent(0.6) }
        }
    }
    
    class func routeColorForIndex(index: Int) -> UIColor {
        return routeColors[index % routeColors.count]
    }
}
