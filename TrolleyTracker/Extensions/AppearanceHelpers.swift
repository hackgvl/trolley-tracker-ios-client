//
//  UIViewController+Appearance.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/26/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

struct AppearanceHelper {
    private init() {}

    static func setAppColors() {
        UINavigationBar.setDefaultAppearance()
        UITabBar.setDefaultAppearance()
        SolidButton.setAppearance()
    }

    static func setLightNavigationColors() {
        UINavigationBar.setLightAppearance()
    }
    static func setDefaultNavigationAppearance() {
        UINavigationBar.setDefaultAppearance()
    }
}

private extension UINavigationBar {
    
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

private extension UITabBar {
    
    class func setDefaultAppearance() {
        UITabBar.appearance().barTintColor = .ttMediumPurple()
        UITabBar.appearance().tintColor = .ttTintColor()
    }
}

private extension SolidButton {
    static func setAppearance() {
        SolidButton.appearance().backgroundColor = .white
        SolidButton.appearance().titleColor = .ttAlternateTintColor()
    }
}

extension UIButton {

    var titleColor: UIColor? {
        get { return titleColor(for: .normal) }
        set { setTitleColor(newValue, for: .normal) }
    }
}
