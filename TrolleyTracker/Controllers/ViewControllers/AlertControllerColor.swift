//
//  AlertControllerColor.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/25/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class AlertController: UIAlertController {
    
    var tintColor = UIApplication.shared.keyWindow?.tintColor
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.tintColor = tintColor
    }
}
