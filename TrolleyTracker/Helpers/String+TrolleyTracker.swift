//
//  String+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/29/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit

extension String {
    
    func maxFontSizeForSize(_ maxSize: CGSize, attributes: [NSAttributedStringKey : Any]) -> CGFloat {
        
        var newAttributes = attributes
        let font = newAttributes[.font] as? UIFont ?? UIFont.systemFont(ofSize: 1)
        var lastGoodSize: Int = Int(font.pointSize)
        
        for i in lastGoodSize..<100 {
            
            newAttributes[.font] = font.withSize(CGFloat(lastGoodSize))
            
            let size = (self as NSString).size(withAttributes: newAttributes)
            
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
