//
//  UIImage+TrolleyTracker.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/22/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit


extension UIImage {
    
    class var ttTrolleyPin: UIImage {
        get { return imageOrBlank("TrolleyPin") }
    }
    
    class var ttTrolleyStopPin: UIImage {
        get { return imageOrBlank("TrolleyStopPin") }
    }
    
    class var ttTrolleyTrackerLogo: UIImage {
        get { return imageOrBlank("TROLLEYTRACKER_logo") }
    }
    
    class var ttUserPin: UIImage {
        get { return imageOrBlank("YouAreHere") }
    }
    
    class var ttTrolleyPin1: UIImage {
        get { return imageOrBlank("Marker1") }
    }
    
    class var ttTrolleyPin2: UIImage {
        get { return imageOrBlank("Marker2") }
    }
    
    class var ttTrolleyMarkerImage: UIImage {
        get { return imageOrBlank("TrolleyMarkerImage") }
    }

    class var ttTrolleyStopImage: UIImage {
        get { return imageOrBlank("TrolleyStopRounded") }
    }
    
    
    class var ttLocateMe: UIImage {
        get { return imageOrBlank("LocateMe") }
    }
    
    //
    //    class var tt<#Name#>: UIImage {
    //    get { return imageOrBlank("<#Name#>") }
    //    }
    
    private class func imageOrBlank(named: String) -> UIImage {
        
        if let image = UIImage(named: named) {
            return image
        }
        else {
            println("Error, could not find image named: \(named)")
            return UIImage()
        }
    }
}


extension MKAnnotationView {
    
    func setTintedImage(imageToSet: UIImage) {
        
        let imageView = UIImageView(image: imageToSet.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))
        imageView.tintColor = self.tintColor
        
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, imageView.opaque, 0.0)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.image = image
    }
}