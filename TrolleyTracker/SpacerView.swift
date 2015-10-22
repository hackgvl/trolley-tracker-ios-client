//
//  SpacerView.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/20/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import UIKit

class SpacerView: UIView {

    init(height: CGFloat) {
        super.init(frame: CGRectZero)
        
        self.heightAnchor.constraintEqualToConstant(height).active = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
