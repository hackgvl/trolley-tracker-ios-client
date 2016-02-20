//
//  ScheduleViewCell.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/27/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class ScheduleViewCell: UITableViewCell {

    @IBOutlet var headingLabel: UILabel!
    @IBOutlet var timesLabel: UILabel!
    
    func displayItem(item: ScheduleItem) {
        selectionStyle = item.selectable ? .Gray : .None
        accessoryType = item.selectable ? .DisclosureIndicator : .None
        headingLabel.text = item.title
        timesLabel.text = item.times.joinWithSeparator("\n")
    }
}
