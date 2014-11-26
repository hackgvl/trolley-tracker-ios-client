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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            var cell: AnyObject = tableView.dequeueReusableCellWithIdentifier("Map", forIndexPath: indexPath)
            
            cell.textLabel.text = "Austin Doesn't have WatchKit"
            
            return cell as UITableViewCell
        }
        else {
            var cell: AnyObject = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
            
            cell.textLabel.text = "Austin Doesn't have WatchKit"
            
            return cell as UITableViewCell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            return 256.0
        }
        
        return 64.0
    }

}

