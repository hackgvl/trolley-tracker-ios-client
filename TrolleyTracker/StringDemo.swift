//
//  StringDemo.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 5/9/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

extension UITabBarController {

    func setLocalizedStrings() {
        for (index, viewController) in viewControllers!.enumerated() {
            switch index {
            case 0:
                viewController.tabBarItem.title = NSLocalizedString("Map.tabBarTitle", comment: "")
            case 1:
                viewController.tabBarItem.title = NSLocalizedString("Schedule.tabBarTitle", comment: "")
            default:
                break
            }
        }
    }
}
