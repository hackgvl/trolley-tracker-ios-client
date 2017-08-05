//
//  ZLayer.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/5/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import UIKit

class ZLayer: CALayer {

    var zOffset: CGFloat = 0

    override var zPosition: CGFloat {
        get { return super.zPosition }
        set {
            var finalZ = newValue
            if finalZ < zOffset {
                finalZ += zOffset
            }
            super.zPosition = finalZ
        }
    }
}
