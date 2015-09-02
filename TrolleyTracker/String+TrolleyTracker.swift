//
//  String+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/29/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension String {
    
    func maxFontSizeForSize(maxSize: CGSize, attributes: [String : AnyObject]) -> CGFloat {
        
        var newAttributes = attributes
        let font = newAttributes[NSFontAttributeName] as? UIFont ?? UIFont.systemFontOfSize(1)
        var lastGoodSize: Int = Int(font.pointSize)
        
        for i in lastGoodSize..<100 {
            
            newAttributes[NSFontAttributeName] = font.fontWithSize(CGFloat(lastGoodSize))
            
            let size = (self as NSString).sizeWithAttributes(newAttributes)
            
            if size.width < maxSize.width && size.height < maxSize.height {
                lastGoodSize = i
            }
            else {
                break
            }
        }
        
        return CGFloat(lastGoodSize)
    }
}
