//
//  MoreController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MoreController: FunctionController {

    private let viewController: MoreViewController
    private let dataSource: MoreDataSource

    override init() {
        let vc = MoreViewController()
        self.viewController = vc
        let ds = SettingsDataSource(presentationController: vc)
        self.dataSource = MoreDataSource(settingsDataSource: ds)
    }

    func prepare() -> UIViewController {

        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 0)

        viewController.tableView.dataSource = dataSource
        viewController.tableView.delegate = dataSource

        let nav = UINavigationController(rootViewController: viewController)

        return nav
    }
}
