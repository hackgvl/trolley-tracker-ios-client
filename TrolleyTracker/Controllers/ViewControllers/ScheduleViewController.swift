//
//  ScheduleViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

private enum ScheduleDisplayType: Int {
    case route, day
    
    fileprivate func displayString() -> String {
        switch self {
        case .route:
            return "By Route"
        case .day:
            return "By Day"
        }
    }
}

class ScheduleViewController: UIViewController, UINavigationBarDelegate, StoryboardInjectable {

    typealias ViewControllerDependencies = ApplicationController

    let ScheduleHeaderViewIdentifier = "ScheduleHeaderViewIdentifier"
    
    var scheduleDataSource: [ScheduleSection]?
    fileprivate let appController: ApplicationController
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 60
            tableView.rowHeight = UITableViewAutomaticDimension
            tableView.register(ScheduleHeaderView.self, forHeaderFooterViewReuseIdentifier: ScheduleHeaderViewIdentifier)
        }
    }
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    fileprivate var schedules = [RouteSchedule]()
    
    fileprivate var schedulesByDaySections: [ScheduleSection]?
    fileprivate var schedulesByRouteSections: [ScheduleSection]?

    @IBOutlet weak var scheduleFormattingSegmentedControl: UISegmentedControl!

    required init?(coder aDecoder: NSCoder) {
        self.appController = ScheduleViewController.getDependencies()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.barTintColor = UIColor.ttAlternateTintColor()
        view.backgroundColor = UIColor.ttLightGray()
        
        scheduleFormattingSegmentedControl.tintColor = UIColor.ttLightGray()
        scheduleFormattingSegmentedControl.selectedSegmentIndex = ScheduleDisplayType.route.rawValue
        for displayType in [ScheduleDisplayType.route, ScheduleDisplayType.day] {
            scheduleFormattingSegmentedControl.setTitle(displayType.displayString(), forSegmentAt: displayType.rawValue)
        }
        
        appController.trolleyScheduleService.loadTrolleySchedules { (schedules) -> Void in
            DispatchQueue.main.async {
                self.schedules = schedules
                self.clearCachedViews()
                self.displaySchedulesByRoute(schedules)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    fileprivate func clearCachedViews() {
        schedulesByDaySections = nil
        schedulesByRouteSections = nil
    }
    
    @IBAction func scheduleFormattingControlValueChanged(_ sender: UISegmentedControl) {
        guard let displayType = ScheduleDisplayType(rawValue: sender.selectedSegmentIndex) else { return }
        switch displayType {
        case .route:
            displaySchedulesByRoute(schedules)
        case .day:
            displaySchedulesByDay(schedules)
        }
    }
    
    fileprivate func displaySchedulesByDay(_ schedules: [RouteSchedule]) {
        
        // If we have cached items, use them
        if let sections = schedulesByDaySections {
            updateScheduleDataSourceWithSections(sections)
            return
        }
        
        schedulesByDaySections = itemsForSchedulesByDay(schedules)
        updateScheduleDataSourceWithSections(schedulesByDaySections!)
    }
    
    fileprivate func displaySchedulesByRoute(_ schedules: [RouteSchedule]) {
        
        // If we have cached views, use them
        if let sections = schedulesByRouteSections {
            updateScheduleDataSourceWithSections(sections)
            return
        }
        
        schedulesByRouteSections = itemsForSchedulesSortedByRoute(schedules)
        updateScheduleDataSourceWithSections(schedulesByRouteSections!)
    }
    
    fileprivate func updateScheduleDataSourceWithSections(_ sections: [ScheduleSection]) {
        scheduleDataSource = sections
        tableView.reloadData()
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }
    
    fileprivate func displayRoute(_ routeID: Int) {
        RouteDetailViewController.setDependencies(appController)
        let controller = storyboard?.instantiateViewController(withIdentifier: String(describing: RouteDetailViewController.self)) as! RouteDetailViewController
        controller.routeID = routeID
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return scheduleDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleDataSource?[section].items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = scheduleDataSource![(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell") as! ScheduleViewCell
        
        cell.displayItem(item)
        
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ScheduleHeaderViewIdentifier) as! ScheduleHeaderView
        let section = scheduleDataSource![section]
        
        view.tapAction = displayRoute
        view.displaySection(section)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 14
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = scheduleDataSource![(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).row]
        guard item.selectable else { return }
        displayRoute(item.routeID)
    }
}
