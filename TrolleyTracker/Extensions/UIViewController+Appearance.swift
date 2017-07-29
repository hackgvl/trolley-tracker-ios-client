//
//  UIViewController+Appearance.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/26/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension UINavigationBar {
    
    class func setDefaultAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.ttMediumPurple()
        UINavigationBar.appearance().tintColor = UIColor.ttTintColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ttLightTextColor()]
    }
    
    class func setLightAppearance() {
        UINavigationBar.appearance().barTintColor = UIColor.ttTintColor()
        UINavigationBar.appearance().tintColor = UIColor.ttAlternateTintColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.ttAlternateTintColor()]
    }
}

extension UITabBar {
    
    class func setDefaultAppearance() {
        UITabBar.appearance().barTintColor = UIColor.ttMediumPurple()
    }
}
