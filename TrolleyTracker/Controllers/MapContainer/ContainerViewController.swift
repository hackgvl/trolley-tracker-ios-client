//
//  ContainerViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

protocol ContainerVCDelegate: class {

}

class ContainerViewController: UIViewController {

    weak var delegate: ContainerVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.image = #imageLiteral(resourceName: "Map")
        tabBarItem.title = "Map"

        view.backgroundColor = .red
    }
}
