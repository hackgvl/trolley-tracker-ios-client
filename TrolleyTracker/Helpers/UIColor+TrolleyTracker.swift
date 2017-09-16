//
//  UIColor+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/20/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

enum GreenlinkColor {
    case heartOfMain, topOfMain, artsWest, augusta

    init?(routeName: String) {
        switch routeName {
        case "HeartOfMain":
            self = .heartOfMain
        case "TopOfMain":
            self = .topOfMain
        case "ArtsWest":
            self = .artsWest
        case "Augusta":
            self = .augusta
        default:
            return nil
        }
    }

    var color: UIColor {
        switch self {
        case .artsWest: return .rgb(145, 188, 86)
        case .augusta: return .rgb(125, 121, 167)
        case .heartOfMain: return .rgb(153, 49, 47)
        case .topOfMain: return .rgb(247, 189, 59)
        }
    }
}

extension UIColor {

    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    class func ttTintColor() -> UIColor { return UIColor.white }
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
    
    class func ttLightGray() -> UIColor { return UIColor(red:0.94, green:0.94, blue:0.96, alpha:1) }
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
            
            return colors.map { $0.withAlphaComponent(1.0) }
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
            
            return colors.map { $0.withAlphaComponent(1.0) }
        }
    }

    class func routeColorForIndex(_ index: Int) -> UIColor {
        return routeColors[index % routeColors.count]
    }
    
    class func stopColorForIndex(_ index: Int) -> UIColor {
        return stopColors[index % stopColors.count]
    }
}

extension UIColor {
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff

        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
