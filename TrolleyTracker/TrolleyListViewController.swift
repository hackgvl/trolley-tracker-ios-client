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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        return dataController.trolleys[section].upcomingStops.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let trolley = dataController.trolleys[indexPath.section]
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as TrolleyListHeaderCell
            
            cell.labelForTrolleyTitle.text = trolley.name
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("StopCell", forIndexPath: indexPath) as TrolleyListTableViewCell
            
            let trolleyStop = trolley.upcomingStops[indexPath.row - 1]
            
            cell.labelForNextDestination.text = trolleyStop.name
            cell.labelForTimeDescription.text = "mins"
            
            if let trolleyLocation = trolley.currentLocation {
                cell.labelForTrolleyDestinationTime.text = trolleyStop.travelTimeFromLocation(trolleyLocation, transportationType: .Trolley)
            }
            
            if let userLocation = User.currentLocation {
                cell.labelForUserDestinationTime.text = trolleyStop.travelTimeFromLocation(userLocation, transportationType: .Walking)
            }
            
            return cell
        }
    }
    

}
