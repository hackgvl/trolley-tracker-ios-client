//
//  TrolleyAnnotationView.swift
//  
//
//  Created by Austin Younts on 8/28/15.
//
//

import UIKit
import MapKit

class TrolleyAnnotationView: MKAnnotationView {
    
    /// Will be shown on the view
    var trolleyNumber: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var labelText: String {
        get { return "#\(trolleyNumber)" }
    }

    private let innerColorAlpha: CGFloat = 0.9
    private let outerColorAlpha: CGFloat = 0.5
    
    private let outerCirclePercentage: CGFloat = 0.9 // The diameter of the outer circle, as a percentage of the view's size
    private let innerCirclePercentage: CGFloat = 0.73 // The diameter of the inner circle, as a percentage of the view's size
    
    private let outerCircleWidthPercentage: CGFloat = 0.08 // The line width of the outerCircle, as a percentage of the view's width
    
    private let imageInsetPercentage: CGFloat = 0.35 // The size of the image, as a precentage of the view's size
    private let verticalImageOffsetPercent: CGFloat = 0.1 // Controls how far the image is shifted vertically, as a percentage of the view's height
    
    private let textWidthPercentage: CGFloat = 0.5 // The width of the text area, as a percentage of the view's width
    private let textHeightPercentage: CGFloat = 0.25 // The height of the text area, as a percentage of the view's height
    private let textHeightOffset: CGFloat = -0.035 // The vertical offset of the text, starting at the bottom of the image, as a percentage of the view's height
    
    override func drawRect(rect: CGRect) {
        
        let innerColor = tintColor.colorWithAlphaComponent(innerColorAlpha)
        let outerColor = tintColor.colorWithAlphaComponent(outerColorAlpha)
        
        // Outer circle/ring
        let outerCircle = UIBezierPath(ovalInRect: insetRect(rect, toPercent: outerCirclePercentage))
        outerColor.setStroke()
        outerCircle.lineWidth = CGRectGetWidth(rect) * outerCircleWidthPercentage
        outerCircle.stroke()
        
        // Inner circle
        let innerCircle = UIBezierPath(ovalInRect: insetRect(rect, toPercent: innerCirclePercentage))
        innerColor.setFill()
        innerCircle.fill()
        
        // Trolley image
        var imageRect = insetRect(rect, toPercent: imageInsetPercentage)
        imageRect = CGRectOffset(imageRect, 0, -(CGRectGetHeight(rect) * verticalImageOffsetPercent))
        let trolleyImage = UIImage.ttTrolleyMarkerImage
        trolleyImage.drawInRect(imageRect)
        
        // Trolley label text
        var labelRect = CGRectMake(0, 0, CGRectGetWidth(rect) * textWidthPercentage, CGRectGetHeight(rect) * textHeightPercentage)
        labelRect.origin.x = CGRectGetMidX(rect) - (CGRectGetWidth(labelRect) / 2)
        labelRect.origin.y = CGRectGetMaxY(imageRect) + (CGRectGetHeight(rect) * textHeightOffset)
        
        var paragraphStyle = NSParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var attributes: [NSObject : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSParagraphStyleAttributeName : paragraphStyle,
            NSFontAttributeName : UIFont.ttDefaultFont(6)
        ]
        
        let maxFontSize = labelText.maxFontSizeForSize(labelRect.size, attributes: attributes)
        attributes[NSFontAttributeName] = UIFont.ttDefaultFont(maxFontSize)
        
        (labelText as NSString).drawInRect(labelRect, withAttributes: attributes)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        backgroundColor = UIColor.clearColor()
    }
}
