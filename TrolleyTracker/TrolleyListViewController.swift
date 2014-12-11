//
//  TrolleyListViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/10/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit

class TrolleyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataController: TrolleyDataController!
    
    @IBOutlet weak var tableView: UITableView!
    
    override init() {
        super.init(nibName: "TrolleyListViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "TrolleyListTableViewCell", bundle: nil)
        tableView?.registerNib(cellNib, forCellReuseIdentifier: NSStringFromClass(TrolleyListTableViewCell.self))
    }

    // MARK: Actions
    
    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: UITableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataController.trolleys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(TrolleyListTableViewCell.self)) as TrolleyListTableViewCell
        let trolley = dataController.trolleys[indexPath.section]
        
        return cell
    }
    

}
