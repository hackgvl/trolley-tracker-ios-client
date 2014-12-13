//
//  ViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 11/18/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let dataController = TrolleyDataController()
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //        locationManager.startUpdatingLocation()
        
        
        self.title = "Track the Trolley"
        
        self.view.backgroundColor = UIColor.redColor()
        
        var tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        tableView.registerClass(MapTableViewCell.classForCoder(), forCellReuseIdentifier: "Map")
        
        self.view.addSubview(tableView)
        
        self.tableView = tableView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "listButtonTapped:")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView?.indexPathForSelectedRow() {
            tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    func listButtonTapped(sender: UIBarButtonItem) {
        
        let nc = UIStoryboard(name: "TrolleyList", bundle: nil).instantiateInitialViewController() as UINavigationController
        nc.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        nc.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        
        let controller = nc.topViewController as TrolleyListViewController
        controller.dataController = dataController
        
        presentViewController(nc, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("Map", forIndexPath: indexPath) as UITableViewCell
            
            cell.textLabel?.text = "Austin Doesn't have WatchKit"
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
            let trolley = dataController.trolleys[indexPath.row]
            cell.textLabel?.text = trolley.name
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            return 256.0
        }
        
        return 64.0
    }

}

