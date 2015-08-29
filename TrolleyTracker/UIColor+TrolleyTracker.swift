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
    class func ttAlternateTintColor() -> UIColor { return UIColor.ttDarkPurple() }
    
    class func ttLightTextColor() -> UIColor { return UIColor.ttLightGray() }
    
    class func ttRouteColor1() -> UIColor { return UIColor(red:0.239, green:0.192, blue:0.356, alpha:1) }
    class func ttStopColor1() -> UIColor { return UIColor(red:0.462, green:0.349, blue:0.819, alpha:1) }
    class func ttRouteColor2() -> UIColor { return UIColor(red:0.439, green:0.545, blue:0.458, alpha:1) }
    class func ttStopColor2() -> UIColor { return UIColor(red:0.603, green:0.721, blue:0.478, alpha:1) }
    class func ttRouteColor3() -> UIColor { return UIColor(red:0.937, green:0.784, blue:0.094, alpha:1) }
    class func ttStopColor3() -> UIColor { return UIColor(red:0.996, green:0.874, blue:0.4, alpha:1) }
    class func ttRouteColor4() -> UIColor { return UIColor(red:0.035, green:0.454, blue:0.313, alpha:1) }
    class func ttStopColor4() -> UIColor { return UIColor(red:0.239, green:0.878, blue:0.647, alpha:1) }
    class func ttRouteColor5() -> UIColor { return UIColor(red:0.168, green:0.176, blue:0.258, alpha:1) }
    class func ttStopColor5() -> UIColor { return UIColor(red:0.552, green:0.6, blue:0.682, alpha:1) }
    
    class func ttMediumPurple() -> UIColor { return UIColor(red:0.317, green:0.333, blue:0.513, alpha:1) }
    class func ttDarkPurple() -> UIColor { return UIColor(red:0.211, green:0.231, blue:0.45, alpha:1) }
    
    class func ttLightGreen() -> UIColor { return UIColor(red:0.678, green:0.721, blue:0.117, alpha:1) }
    
    class func ttLightGray() -> UIColor { return UIColor(red:0.886, green:0.886, blue:0.886, alpha:1) }
    class func ttDarkGray() -> UIColor { return UIColor(red:0.2, green:0.2, blue:0.2, alpha:1) }
    
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
//    class func tt<#Name#>() -> UIColor { return <#Color#> }
    
    class var routeColors: [UIColor] {
        get {
            
            let colors = [
                UIColor.ttRouteColor4(),
                UIColor.ttRouteColor3(),
                UIColor.ttRouteColor2(),
                UIColor.ttRouteColor1(),
                UIColor.ttRouteColor5()
            ]
            
            return colors.map { $0.colorWithAlphaComponent(1.0) }
        }
    }
    
    class var stopColors: [UIColor] {
        get {
            
            let colors = [
                UIColor.ttStopColor4(),
                UIColor.ttStopColor3(),
                UIColor.ttStopColor2(),
                UIColor.ttStopColor1(),
                UIColor.ttStopColor5()
            ]
            
            return colors.map { $0.colorWithAlphaComponent(1.0) }
        }
    }
    
    class var trolleyColors: [UIColor] {
        get {
            
            let colors = [
                UIColor.ttDarkPurple(),
                UIColor.ttLightGreen()
            ]
            
            return colors
        }
    }
    
    class func routeColorForIndex(index: Int) -> UIColor {
        return routeColors[index % routeColors.count]
    }
    
    class func stopColorForIndex(index: Int) -> UIColor {
        return stopColors[index % stopColors.count]
    }
    
    class func trolleyColorForID(id: Int) -> UIColor {
        return trolleyColors[id % trolleyColors.count]
    }
}
