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
    
    fileprivate let innerCirclePercentage: CGFloat = 0.7 // The diameter of the inner circle, as a percentage of the view's size
    fileprivate let innerCircleWidthPercentage: CGFloat = 0.035 // The line width of the inner circle, as a percentage of the view's width
    fileprivate let innerCircleVerticalOffsetPercentage: CGFloat = 0.05 // The vertical offset of the inner circle, as a percentage of the view's height

    override func draw(_ rect: CGRect) {

        // Teardrop shape
        let teardropPath = tearDropPathInRect(rect)
        tintColor.setFill()
        teardropPath.fill()
        
        // White inner circle
        var circleRect = insetRect(rect, toPercent: innerCirclePercentage)
        circleRect = circleRect.offsetBy(dx: 0, dy: rect.height * innerCircleVerticalOffsetPercentage)
        circleRect.size.height = circleRect.size.width
        let circlePath = UIBezierPath(ovalIn: circleRect)
        circlePath.lineWidth = rect.width * innerCircleWidthPercentage
        UIColor.white.setStroke()
        circlePath.stroke()
        
        // Stop Image
        let image = UIImage.ttTrolleyStopImage
        image.draw(in: circleRect)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        backgroundColor = UIColor.clear
    }
    
    
    fileprivate func tearDropPathInRect(_ rect: CGRect) -> UIBezierPath {
        
        let halfCircleY = rect.height / 3
        let verticalPadding: CGFloat = rect.height * 0.05
        let minY: CGFloat = verticalPadding
        let maxY: CGFloat = rect.height - verticalPadding
        let minX: CGFloat = 0
        let maxX: CGFloat = rect.width
        
        let xControlPointUpperInsetPercent: CGFloat = 0.02
        let xControlPointLowerInsetPercent: CGFloat = 0.3
        let yControlPointMaxPercent: CGFloat = 0.8
        let yControlPointMinPercent: CGFloat = 0.1
        
        let firstControlPointX: CGFloat = rect.width * xControlPointUpperInsetPercent // For the top-center to mid-left curve
        let firstControlPointY: CGFloat = rect.height * yControlPointMinPercent
        
        let secondControlPointX: CGFloat = rect.width * xControlPointLowerInsetPercent // For the mid-left to bottom-center curve
        let secondControlPointY: CGFloat = rect.height * yControlPointMaxPercent
        
        let thirdControlPointX: CGFloat = rect.width * CGFloat(1 - xControlPointLowerInsetPercent) // For the bottom-center to mid-right curve
        let thirdControlPointY: CGFloat = rect.height * yControlPointMaxPercent
        
        let fourthControlPointX: CGFloat = rect.width * CGFloat(1 - xControlPointUpperInsetPercent) // For the mid-right to top-center curve
        let fourthControlPointY: CGFloat = rect.height * yControlPointMinPercent
        
        
        let path = UIBezierPath()
        path.miterLimit = 5
        
        path.move(to: CGPoint(x: rect.midX, y: minY)) // Start at top middle
        path.addQuadCurve(to: CGPoint(x: minX, y: halfCircleY), controlPoint: CGPoint(x: firstControlPointX, y: firstControlPointY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: maxY), controlPoint: CGPoint(x: secondControlPointX, y: secondControlPointY))
        path.addQuadCurve(to: CGPoint(x: maxX, y: halfCircleY), controlPoint: CGPoint(x: thirdControlPointX, y: thirdControlPointY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: minY), controlPoint: CGPoint(x: fourthControlPointX, y: fourthControlPointY))

        return path
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        
        layer.shadowColor = selected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
}
