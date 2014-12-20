//
//  TrolleyListTableViewCell.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/10/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit

class TrolleyListTableViewCell: UITableViewCell {

    @IBOutlet weak var labelForTrolleyDestinationTime: UILabel!
    @IBOutlet weak var labelForTimeDescription: UILabel!
    @IBOutlet weak var labelForNextDestination: UILabel!
    @IBOutlet weak var labelForUserDestinationTime: UILabel!
    
    var viewModel: TrolleyStopViewModel? {
        didSet {
            labelForNextDestination.text = viewModel?.name
            labelForTimeDescription.text = "mins"
            labelForTrolleyDestinationTime.text = viewModel?.trolleyTime
            labelForUserDestinationTime.text = viewModel?.walkingTime
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
