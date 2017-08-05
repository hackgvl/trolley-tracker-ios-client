//
//  SolidButton.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/5/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class SolidButton: UIButton {

    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 10
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        return contentRect.insetBy(dx: 4, dy: 0)
    }
}
