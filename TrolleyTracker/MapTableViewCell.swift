//
//  MapTableViewCell.swift
//  TrolleyTracker
//
//  Created by Ryan Poolos on 11/18/14.
//  Copyright (c) 2014 Code For Greenville. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewCell: UITableViewCell {
    
    var mapView: MKMapView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.mapView = MKMapView(frame: self.contentView.bounds)
        
        if let mapView = self.mapView {
            mapView.autoresizingMask = UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleWidth
            
            let region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(34.851887, -82.398366), MKCoordinateSpanMake(0.001, 0.001))
            mapView.region = region
            mapView.showsUserLocation = true
            //mapView.userLocation.coordinate
            
            self.contentView.addSubview(mapView)
        }
        
        self.textLabel?.hidden = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
