//
//  MapLayerCell.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class MapLayerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func populate(with collection: MapLayerItemCollection) {
        textLabel?.text = collection.name
    }

}
