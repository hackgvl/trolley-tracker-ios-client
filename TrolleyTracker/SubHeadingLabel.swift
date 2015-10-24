//
//  SubHeadingLabel.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/24/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class SubHeadingLabel: UILabel {

    init(text: String) {
        
        super.init(frame: CGRectZero)
        
        self.text = text
        self.numberOfLines = 0
        self.font = UIFont.italicSystemFontOfSize(12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
