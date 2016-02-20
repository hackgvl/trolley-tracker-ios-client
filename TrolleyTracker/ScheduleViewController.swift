//
//  ScheduleViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

private enum ScheduleDisplayType: Int {
    case Route, Day
    
    private func displayString() -> String {
        switch self {
        case .Route:
            return "By Route"
        case .Day:
            return "By Day"
        }
    }
}

class ScheduleViewController: UIViewController, UINavigationBarDelegate {
    
    let ScheduleHeaderViewIdentifier = "ScheduleHeaderViewIdentifier"
    
    var scheduleDataSource: [ScheduleSection]?
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.registerClass(ScheduleHeaderView.self, forHeaderFooterViewReuseIdentifier: ScheduleHeaderViewIdentifier)
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    private var schedules = [RouteSchedule]()
    
    private var schedulesByDaySections: [ScheduleSection]?
    private var schedulesByRouteSections: [ScheduleSection]?

    @IBOutlet weak var scheduleFormattingSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.barTintColor = UIColor.ttAlternateTintColor()
        view.backgroundColor = UIColor.ttLightGray()
        
        scheduleFormattingSegmentedControl.tintColor = UIColor.ttLightGray()
        scheduleFormattingSegmentedControl.selectedSegmentIndex = ScheduleDisplayType.Route.rawValue
        for displayType in [ScheduleDisplayType.Route, ScheduleDisplayType.Day] {
            scheduleFormattingSegmentedControl.setTitle(displayType.displayString(), forSegmentAtIndex: displayType.rawValue)
        }
        
        TrolleyScheduleService.sharedService.loadTrolleySchedules { (schedules) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.schedules = schedules
                self.displaySchedulesByRoute(schedules)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func scheduleFormattingControlValueChanged(sender: UISegmentedControl) {
        guard let displayType = ScheduleDisplayType(rawValue: sender.selectedSegmentIndex) else { return }
        switch displayType {
        case .Route:
            displaySchedulesByRoute(schedules)
        case .Day:
            displaySchedulesByDay(schedules)
        }
    }
    
    private func displaySchedulesByDay(schedules: [RouteSchedule]) {
        
        // If we have cached items, use them
        if let sections = schedulesByDaySections {
            updateScheduleDataSourceWithSections(sections)
            return
        }
        
        schedulesByDaySections = itemsForSchedulesByDay(schedules)
        updateScheduleDataSourceWithSections(schedulesByDaySections!)
    }
    
    private func displaySchedulesByRoute(schedules: [RouteSchedule]) {
        
        // If we have cached views, use them
        if let sections = schedulesByRouteSections {
            updateScheduleDataSourceWithSections(sections)
            return
        }
        
        schedulesByRouteSections = itemsForSchedulesSortedByRoute(schedules)
        updateScheduleDataSourceWithSections(schedulesByRouteSections!)
    }
    
    private func updateScheduleDataSourceWithSections(sections: [ScheduleSection]) {
        scheduleDataSource = sections
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    private func displayRoute(routeID: Int) {
        let controller = storyboard?.instantiateViewControllerWithIdentifier(String(RouteDetailViewController)) as! RouteDetailViewController
        controller.routeID = routeID
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return scheduleDataSource?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleDataSource?[section].items.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = scheduleDataSource![indexPath.section].items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ScheduleCell") as! ScheduleViewCell
        
        cell.displayItem(item)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(ScheduleHeaderViewIdentifier) as! ScheduleHeaderView
        let section = scheduleDataSource![section]
        
        view.tapAction = displayRoute
        view.displaySection(section)
        
        return view
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let item = scheduleDataSource![indexPath.section].items[indexPath.row]
        guard item.selectable else { return }
        displayRoute(item.routeID)
    }
}
