//
//  TrolleyListViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/10/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit

class TrolleyListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TrolleyDataControllerDelegate {

    var dataController: TrolleyDataController! {
        didSet {
            dataController.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(TrolleyListHeaderCell.self, forCellReuseIdentifier: headerCellIdentifier)
        tableView.registerClass(TrolleyListTableViewCell.self, forCellReuseIdentifier: TrolleyStopCellIdentifier)
    }

    // MARK: Actions
    
    @IBAction func closeButtonTapped(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //==========================================================================
    // mark: UITableViewDataSource
    //==========================================================================
    
    let headerCellIdentifier = "HeaderCell"
    let TrolleyStopCellIdentifier = "TrolleyStopCell"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataController.trolleys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataController.trolleys[section].upcomingStops.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let trolley = dataController.trolleys[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(headerCellIdentifier, forIndexPath: indexPath) as! TrolleyListHeaderCell
            
            cell.labelForTrolleyTitle.text = trolley.name
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(TrolleyStopCellIdentifier, forIndexPath: indexPath) as! TrolleyListTableViewCell
            
            let trolleyStop = trolley.upcomingStops[indexPath.row - 1]

            cell.viewModel = trolleyStop
            
            return cell
        }
    }
    
    
    func controller(_: TrolleyDataController, didUpdateTrolleyStop stop: TrolleyStopViewModel) {
        tableView.reloadData()
    }
    
    func controllerDidChangeTrolleyStops(controller: TrolleyDataController) {
        tableView.reloadData()
    }
    
    func controller(_: TrolleyDataController, didUpdateTrolleyLocation trolley: TrolleyViewModel) {
        
    }
    
    func controllerDidUpdateTrolleyList(controller: TrolleyDataController) {
        
    }

}
