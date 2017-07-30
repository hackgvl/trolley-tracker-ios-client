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
}
