//
//  TrolleyStopAnnotationView.swift
//  
//
//  Created by Austin Younts on 8/29/15.
//
//

import UIKit
import MapKit

private extension CGFloat {
    static let imageInset: CGFloat = 3
    static let outlineWidth: CGFloat = 1
    static let outlineInset: CGFloat = 1
}
private extension UIColor {
    static let outlineColor = UIColor(white: 1, alpha: 0.6)
    static let fillColor = UIColor.white
}
private extension UIImage {
    static let stopImage = #imageLiteral(resourceName: "TrolleyStopRounded")
}

class TrolleyStopAnnotationView: MKAnnotationView {

    override func draw(_ rect: CGRect) {

        // Tint color circle
        tintColor.setFill()
        let stopPath = UIBezierPath.stopSign(in: rect)
        stopPath.fill()

        // Stop image
        UIColor.fillColor.setFill()
        let imageRect = rect.insetBy(dx: .imageInset, dy: .imageInset)
        UIImage.stopImage.draw(in: imageRect)

        // Contrast outline
        let innerRect = rect.insetBy(dx: .outlineInset, dy: .outlineInset)
        let insetStopPath = UIBezierPath.stopSign(in: innerRect)
        insetStopPath.lineWidth = .outlineWidth
        UIColor.outlineColor.setStroke()
        insetStopPath.stroke()
    }

    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        
        layer.shadowColor = selected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
}

private extension UIBezierPath {

    static func stopSign(in rect: CGRect) -> UIBezierPath {

        let xStart = rect.origin.x
        let x0 = xStart
        let x1 = (rect.width * 0.333) + xStart
        let x2 = (rect.width * 0.666) + xStart
        let x3 = rect.width + xStart

        let yStart = rect.origin.y
        let y0 = yStart
        let y1 = (rect.height * 0.333) + yStart
        let y2 = (rect.height * 0.666) + yStart
        let y3 = rect.height + yStart

        let points: [CGPoint] = [
            CGPoint(x: x1, y: y0),
            CGPoint(x: x2, y: y0),
            CGPoint(x: x3, y: y1),
            CGPoint(x: x3, y: y2),
            CGPoint(x: x2, y: y3),
            CGPoint(x: x1, y: y3),
            CGPoint(x: x0, y: y2),
            CGPoint(x: x0, y: y1)
        ]

        let path = UIBezierPath()

        for (index, point) in points.enumerated() {

            if index == 0 {
                path.move(to: point)
            }
            else {
                path.addLine(to: point)
            }
        }

        path.addLine(to: points[0])

        path.close()

        return path
    }
}
