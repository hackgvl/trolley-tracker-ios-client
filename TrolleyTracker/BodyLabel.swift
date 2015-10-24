//
//  BodyLabel.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/20/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class BodyLabel: UILabel {

    init(text: String) {
        
        super.init(frame: CGRectZero)
        
        self.text = text
        self.numberOfLines = 0
        self.font = UIFont.systemFontOfSize(12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
