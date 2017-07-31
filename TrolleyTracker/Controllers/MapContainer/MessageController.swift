//
//  MessageController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MessageController: FunctionController {

    private let viewController: MessageViewController

    override init() {
        self.viewController = MessageViewController()
    }

    func prepare() -> UIViewController {
        return viewController
    }

//    @IBAction func handleNoTrolleyLabelTap(_ sender: UITapGestureRecognizer) {
//        // TODO: Transfer to message controller
//        tabBarController?.selectedIndex = 1
//    }

    //        noTrolleyLabel.text = "No Trolleys are being tracked right now.\nView the Schedule to see run times and select a route to preview it on the map."
    //
    //        noTrolleyLabel.backgroundColor = UIColor.ttLightGreen()
    //        noTrolleyLabel.textColor = UIColor.white
}
