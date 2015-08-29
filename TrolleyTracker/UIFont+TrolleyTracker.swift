//
//  UIFont+TrolleyTracker.swift
//  
//
//  Created by Austin Younts on 8/29/15.
//
//

import UIKit


extension UIFont {
    
    class func ttDefaultFont(size: CGFloat) -> UIFont {
        let font = UIFont(name: "Montserrat-Bold", size: size)
        return font ?? UIFont.systemFontOfSize(size)
    }
}
