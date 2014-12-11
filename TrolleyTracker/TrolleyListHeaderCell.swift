//
//  TrolleyListHeaderCell.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 12/11/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit

class TrolleyListHeaderCell: UITableViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelForTrolleyTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
