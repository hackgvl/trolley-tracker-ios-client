//
//  TrolleyStopAnnotationView.swift
//  
//
//  Created by Austin Younts on 8/29/15.
//
//

import UIKit
import MapKit

class TrolleyStopAnnotationView: MKAnnotationView {
    
    private let innerCirclePercentage: CGFloat = 0.7 // The diameter of the inner circle, as a percentage of the view's size
    private let innerCircleWidthPercentage: CGFloat = 0.035 // The line width of the inner circle, as a percentage of the view's width
    private let innerCircleVerticalOffsetPercentage: CGFloat = 0.05 // The vertical offset of the inner circle, as a percentage of the view's height

    override func drawRect(rect: CGRect) {

        // Teardrop shape
        let teardropPath = tearDropPathInRect(rect)
        tintColor.setFill()
        teardropPath.fill()
        
        // White inner circle
        var circleRect = insetRect(rect, toPercent: innerCirclePercentage)
        circleRect.offsetInPlace(dx: 0, dy: CGRectGetHeight(rect) * innerCircleVerticalOffsetPercentage)
        circleRect.size.height = circleRect.size.width
        let circlePath = UIBezierPath(ovalInRect: circleRect)
        circlePath.lineWidth = CGRectGetWidth(rect) * innerCircleWidthPercentage
        UIColor.whiteColor().setStroke()
        circlePath.stroke()
        
        // Stop Image
        let image = UIImage.ttTrolleyStopImage
        image.drawInRect(circleRect)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        backgroundColor = UIColor.clearColor()
    }
    
    
    private func tearDropPathInRect(rect: CGRect) -> UIBezierPath {
        
        let halfCircleY = CGRectGetHeight(rect) / 3
        let verticalPadding: CGFloat = CGRectGetHeight(rect) * 0.05
        let minY: CGFloat = verticalPadding
        let maxY: CGFloat = CGRectGetHeight(rect) - verticalPadding
        let minX: CGFloat = 0
        let maxX: CGFloat = CGRectGetWidth(rect)
        
        let xControlPointUpperInsetPercent: CGFloat = 0.02
        let xControlPointLowerInsetPercent: CGFloat = 0.3
        let yControlPointMaxPercent: CGFloat = 0.8
        let yControlPointMinPercent: CGFloat = 0.1
        
        let firstControlPointX: CGFloat = CGRectGetWidth(rect) * xControlPointUpperInsetPercent // For the top-center to mid-left curve
        let firstControlPointY: CGFloat = CGRectGetHeight(rect) * yControlPointMinPercent
        
        let secondControlPointX: CGFloat = CGRectGetWidth(rect) * xControlPointLowerInsetPercent // For the mid-left to bottom-center curve
        let secondControlPointY: CGFloat = CGRectGetHeight(rect) * yControlPointMaxPercent
        
        let thirdControlPointX: CGFloat = CGRectGetWidth(rect) * CGFloat(1 - xControlPointLowerInsetPercent) // For the bottom-center to mid-right curve
        let thirdControlPointY: CGFloat = CGRectGetHeight(rect) * yControlPointMaxPercent
        
        let fourthControlPointX: CGFloat = CGRectGetWidth(rect) * CGFloat(1 - xControlPointUpperInsetPercent) // For the mid-right to top-center curve
        let fourthControlPointY: CGFloat = CGRectGetHeight(rect) * yControlPointMinPercent
        
        
        let path = UIBezierPath()
        path.miterLimit = 5
        
        path.moveToPoint(CGPointMake(CGRectGetMidX(rect), minY)) // Start at top middle
        path.addQuadCurveToPoint(CGPointMake(minX, halfCircleY), controlPoint: CGPointMake(firstControlPointX, firstControlPointY))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMidX(rect), maxY), controlPoint: CGPointMake(secondControlPointX, secondControlPointY))
        path.addQuadCurveToPoint(CGPointMake(maxX, halfCircleY), controlPoint: CGPointMake(thirdControlPointX, thirdControlPointY))
        path.addQuadCurveToPoint(CGPointMake(CGRectGetMidX(rect), minY), controlPoint: CGPointMake(fourthControlPointX, fourthControlPointY))

        return path
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        layer.shadowOffset = CGSizeMake(3, 3)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        
        layer.shadowColor = selected ? UIColor.blackColor().CGColor : UIColor.clearColor().CGColor
    }
}
