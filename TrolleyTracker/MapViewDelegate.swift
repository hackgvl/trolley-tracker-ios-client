//
//  MapViewDelegate.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import MapKit

class TrolleyMapViewDelegate: NSObject, MKMapViewDelegate {
    
    typealias MapViewSelectionAction = (_ annotationView: MKAnnotationView) -> Void
    
    var annotationSelectionAction: MapViewSelectionAction?
    var annotationDeselectionAction: MapViewSelectionAction?
    var shouldShowCallouts: Bool = false
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    let userAnnotationReuseIdentifier = "UserAnnotation"
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var returnView: MKAnnotationView?
        
        if (annotation is MKUserLocation) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: userAnnotationReuseIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userAnnotationReuseIdentifier)
                annotationView!.image = UIImage.ttUserPin
                annotationView!.centerOffset = CGPoint(x: 0, y: -(annotationView!.image!.size.height / 2))
            }
            
            annotationView!.annotation = annotation
            
            returnView = annotationView
        }
            
            // Handle Stops
        else if let stopAnnotation = annotation as? TrolleyStop {
            
            var annotationView: TrolleyStopAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: stopAnnotationReuseIdentifier) as? TrolleyStopAnnotationView
            if annotationView == nil {
                annotationView = TrolleyStopAnnotationView(annotation: annotation, reuseIdentifier: stopAnnotationReuseIdentifier)
                annotationView.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
                annotationView.centerOffset = CGPoint(x: 0, y: -(annotationView.frame.height / 2))
            }
            
            annotationView.canShowCallout = shouldShowCallouts
            annotationView.annotation = annotation
            annotationView.tintColor = UIColor.stopColorForIndex(stopAnnotation.colorIndex)
            
            returnView = annotationView
        }
            
            
            // Handle Trolleys
        else if let trolleyAnnotation = annotation as? Trolley {
            
            var annotationView: TrolleyAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: trolleyAnnotationReuseIdentifier) as? TrolleyAnnotationView
            if annotationView == nil {
                annotationView = TrolleyAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
                annotationView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            }
            
            annotationView.tintColor = UIColor.trolleyColorForID(trolleyAnnotation.ID)
            annotationView.trolleyNumber = trolleyAnnotation.ID
            annotationView.annotation = trolleyAnnotation
            
            returnView = annotationView
        }
        
        DispatchQueue.main.async {
            self.updateAnnotationZIndexesInMapView(mapView)
        }
        
        return returnView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.lineWidth = 6.0
        
        if let routeOverlay = overlay as? TrolleyRouteOverlay {
            renderer.strokeColor = UIColor.routeColorForIndex(routeOverlay.colorIndex)
        }
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        annotationSelectionAction?(view)
        updateAnnotationZIndexesInMapView(mapView)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        annotationDeselectionAction?(view)
        updateAnnotationZIndexesInMapView(mapView)
    }
    
    //    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    //        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
    //        mapView.setRegion(region, animated: true)
    //    }
    
    fileprivate func updateAnnotationZIndexesInMapView(_ mapView: MKMapView) {
        
        for annotation in mapView.annotations {
            if let trolley = annotation as? Trolley,
                let view = mapView.view(for: trolley) {
                    view.superview?.bringSubview(toFront: view)
            }
        }
        
        if let view = mapView.view(for: mapView.userLocation) {
            view.superview?.bringSubview(toFront: view)
        }
    }
}
