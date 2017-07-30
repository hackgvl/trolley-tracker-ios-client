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

    private let mapViewController: UIViewController
    private let detailViewController: UIViewController
    private let messageViewController: UIViewController

    init(mapViewController: UIViewController,
         detailViewController: UIViewController,
         messageViewController: UIViewController) {
        self.mapViewController = mapViewController
        self.detailViewController = detailViewController
        self.messageViewController = messageViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarItem.image = #imageLiteral(resourceName: "Map")
        tabBarItem.title = LS.mapTitle

        view.backgroundColor = .red
    }
}
