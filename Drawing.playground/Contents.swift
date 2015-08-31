//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let rect = CGRectMake(0, 0, 30, 50)
UIGraphicsBeginImageContext(rect.size)


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

//path.lineJoinStyle = kCGLineJoinRound
path.miterLimit = 5

path.moveToPoint(CGPointMake(CGRectGetMidX(rect), minY)) // Start at top middle
path.addQuadCurveToPoint(CGPointMake(minX, halfCircleY), controlPoint: CGPointMake(firstControlPointX, firstControlPointY))
path.addQuadCurveToPoint(CGPointMake(CGRectGetMidX(rect), maxY), controlPoint: CGPointMake(secondControlPointX, secondControlPointY))
path.addQuadCurveToPoint(CGPointMake(maxX, halfCircleY), controlPoint: CGPointMake(thirdControlPointX, thirdControlPointY))
path.addQuadCurveToPoint(CGPointMake(CGRectGetMidX(rect), minY), controlPoint: CGPointMake(fourthControlPointX, fourthControlPointY))

UIColor.redColor().setFill()
path.fill()

let image = UIGraphicsGetImageFromCurrentImageContext()
UIGraphicsEndImageContext()