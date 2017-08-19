//
//  MoreViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped).useAutolayout()
        tv.registerCell(ofType: UITableViewCell.self)
        return tv
    }()
}
