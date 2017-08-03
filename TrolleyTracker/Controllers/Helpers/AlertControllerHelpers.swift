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

extension AlertController {

    static func errorPopup(with message: String) -> AlertController {

        let ac = AlertController(title: LS.genericErrorTitle,
                                 message: message,
                                 preferredStyle: .alert)
        ac.tintColor = .ttAlternateTintColor()
        let action = UIAlertAction(title: LS.genericOKButton,
                                   style: .default,
                                   handler: nil)
        ac.addAction(action)
        return ac
    }
}
