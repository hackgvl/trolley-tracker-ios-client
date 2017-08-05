//
//  Trolley.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit


class Trolley: NSObject {
    
    let ID: Int
    var coordinate: CLLocationCoordinate2D {
        willSet { willChangeValue(forKey: "coordinate") }
        didSet { didChangeValue(forKey: "coordinate") }
    }
    let name: String?
    let number: Int?
    let iconColor: String?
    
    init(identifier: Int, location: CLLocation, name: String?, number: Int?, iconColor: String?) {
        self.name = name
        self.ID = identifier
        self.coordinate = location.coordinate
        self.number = number
        self.iconColor = iconColor
    }
    
    init?(jsonData: Any) {
        
        let json = JSON(jsonData)
        
        let currentLat = json["CurrentLat"].float
        var latitude: String? = currentLat != nil ? String(format: "%.7f", currentLat!) : nil
        if latitude == nil { latitude = json["Lat"].stringValue }
        
        let currentLon = json["CurrentLon"].float
        var longitude: String? = currentLon != nil ? String(format: "%.7f", currentLon!) : nil
        if longitude == nil { longitude = json["Lon"].stringValue }
        
        self.ID = json["ID"].intValue
        self.coordinate = CLLocation(latitude: (latitude! as NSString).doubleValue,
                                     longitude: (longitude! as NSString).doubleValue).coordinate
        
        self.number = json["Number"].int
        self.name = json["TrolleyName"].stringValue// + " - " + "\(self.ID)"
        self.iconColor = json["IconColorRGB"].string
    }
    
    init(trolley: Trolley, location: CLLocation) {
        
        self.ID = trolley.ID
        self.coordinate = location.coordinate
        self.name = trolley.name
        self.number = trolley.number
        self.iconColor = trolley.iconColor
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Trolley , object.ID == self.ID { return true }
        return false
    }
}

extension Trolley {

    var tintColor: UIColor {
        let trimCharacters = CharacterSet(charactersIn: "#")
        let hex = iconColor?.trimmingCharacters(in: trimCharacters) ?? "FFFFFF"
        return UIColor(hex: hex)
    }
}

extension Trolley: MKAnnotation {

    var title: String? {
        return name
    }
    
    @objc(subtitle) var subtitle: String? {
        return ""
    }
}
