//
//  UIView+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/29/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension UIView {
    
    func insetRect(rect: CGRect, toPercent percent: CGFloat) -> CGRect {
        let insetAmount = (CGRectGetWidth(rect) * (1 - percent)) / 2
        return CGRectInset(rect, insetAmount, insetAmount)
    }
}