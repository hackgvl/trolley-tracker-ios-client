//
//  ScheduleViewController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TrolleyScheduleService.sharedService.loadTrolleySchedules { (schedules) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.displaySchedules(schedules)
            }
        }
    }
    
    private func displaySchedules(schedules: [RouteSchedule]) {
        
        for view in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(view)
        }
        
        for schedule in schedules {
            
            // Display name
            stackView.addArrangedSubview(HeadingLabel(text: schedule.name))
            
            for time in schedule.times {
                let timeString = time.day + ", " + time.time
                stackView.addArrangedSubview(BodyLabel(text: timeString))
            }
            
            stackView.addArrangedSubview(SpacerView(height: 14))
        }
    }
}
