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

class ScheduleViewController: UIViewController {
    
    private var schedules = [RouteSchedule]()
    
    private var schedulesByDayViews: [UIView]?
    private var schedulesByRouteViews: [UIView]?

    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var scheduleFormattingSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleFormattingSegmentedControl.tintColor = UIColor.ttAlternateTintColor()
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
        
        // If we have cached views, use them
        if let views = schedulesByDayViews {
            updateScheduleViews(views)
            return
        }
        
        schedulesByDayViews = viewsForSchedulesByDay(schedules)
        self.updateScheduleViews(schedulesByDayViews!)
    }
    
    private func displaySchedulesByRoute(schedules: [RouteSchedule]) {
        
        // If we have cached views, use them
        if let views = schedulesByRouteViews {
            updateScheduleViews(views)
            return
        }
        
        schedulesByRouteViews = viewsForSchedulesSortedByRoute(schedules)
        updateScheduleViews(schedulesByRouteViews!)
    }
    
    private func updateScheduleViews(views: [UIView]) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let stackView = self.stackView
            let superview = self.stackView.superview as! UIStackView
            let stackViewIndex = superview.arrangedSubviews.indexOf(stackView)!
            
            let viewsToRemove = stackView.arrangedSubviews
            
            stackView.removeFromSuperview()
            
            for view in viewsToRemove {
                stackView.removeArrangedSubview(view)
            }
            
            for view in viewsToRemove {
                view.removeFromSuperview()
            }
            
            for view in views {
                stackView.addArrangedSubview(view)
            }
            
            superview.insertArrangedSubview(stackView, atIndex: stackViewIndex)
        }
    }
}
