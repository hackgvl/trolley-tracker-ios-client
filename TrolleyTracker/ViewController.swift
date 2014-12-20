//
//  ViewController.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 11/18/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TrolleyDataControllerDelegate {
    
    let dataController = TrolleyDataController()
    var tableView: UITableView?
    let mapCell = MapTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Map")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Track the Trolley"
        
        self.view.backgroundColor = UIColor.redColor()
        
        var tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.registerNib(UINib(nibName: "TrolleyStopCell", bundle: nil), forCellReuseIdentifier: "TrolleyStopCell")
        tableView.registerClass(MapTableViewCell.classForCoder(), forCellReuseIdentifier: "Map")
        
        self.view.addSubview(tableView)
        
        self.tableView = tableView
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: "listButtonTapped:")
        
        dataController.startTrackingTrolleys()
        
        updateTrolleysOnMap()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView?.indexPathForSelectedRow() {
            tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        dataController.delegate = self
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
        return dataController.trolleys.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            var cell = mapCell
            
            cell.textLabel?.text = "Austin Doesn't have WatchKit"
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("TrolleyStopCell", forIndexPath: indexPath) as TrolleyListTableViewCell
            
            let trolleyStop = dataController.trolleys[indexPath.section - 1].upcomingStops.first
            
            cell.viewModel = trolleyStop
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if (indexPath.section == 0) {
            return 256.0
        }
        
        return 64.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        else {
            return dataController.trolleys[section - 1].name
        }
    }
    
    // MARK: Trolley Locations
    
    func updateTrolleysOnMap() {
        
        mapCell.mapView?.removeAnnotations(mapCell.mapView?.annotations)
        
        for trolley in dataController.trolleys {
            addTrolleyToMap(trolley)
        }
    }
    
    func addTrolleyToMap(trolley: TrolleyViewModel) {
        if let location = trolley.currentLocation {
            
            let annotation = TrolleyMapAnnotation(coordinate: location.coordinate)
            annotation.title = trolley.name
            
            mapCell.mapView?.addAnnotation(annotation)
        }
    }
    
    // MARK: TrolleyDataController Delegate
    
    func controller(_: TrolleyDataController, didUpdateTrolleyLocation trolley: TrolleyViewModel) {
        updateTrolleysOnMap()
    }
    
    func controller(_: TrolleyDataController, didUpdateTrolleyStop stop: TrolleyStopViewModel) {
        tableView?.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(1, dataController.trolleys.count)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func controllerDidChangeTrolleyStops(controller: TrolleyDataController) {
        tableView?.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(1, dataController.trolleys.count)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }

}

