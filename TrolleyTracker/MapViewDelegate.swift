//
//  MapViewDelegate.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/11/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import MapKit

class TrolleyMapViewDelegate: NSObject, MKMapViewDelegate {
    
    typealias MapViewSelectionAction = (annotationView: MKAnnotationView) -> Void
    
    var annotationSelectionAction: MapViewSelectionAction?
    var annotationDeselectionAction: MapViewSelectionAction?
    
    let trolleyAnnotationReuseIdentifier = "TrolleyAnnotation"
    let stopAnnotationReuseIdentifier = "StopAnnotation"
    let userAnnotationReuseIdentifier = "UserAnnotation"
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        var returnView: MKAnnotationView?
        
        if (annotation is MKUserLocation) {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(userAnnotationReuseIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: userAnnotationReuseIdentifier)
                annotationView!.image = UIImage.ttUserPin
                annotationView!.centerOffset = CGPointMake(0, -(annotationView!.image!.size.height / 2))
            }
            
            annotationView!.annotation = annotation
            
            returnView = annotationView
        }
            
            // Handle Stops
        else if let stopAnnotation = annotation as? TrolleyStop {
            
            var annotationView: TrolleyStopAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(stopAnnotationReuseIdentifier) as? TrolleyStopAnnotationView
            if annotationView == nil {
                annotationView = TrolleyStopAnnotationView(annotation: annotation, reuseIdentifier: stopAnnotationReuseIdentifier)
                annotationView.frame = CGRectMake(0, 0, 30, 50)
                annotationView.centerOffset = CGPointMake(0, -(CGRectGetHeight(annotationView.frame) / 2))
            }
            
            annotationView.annotation = annotation
            annotationView.tintColor = UIColor.stopColorForIndex(stopAnnotation.colorIndex)
            
            returnView = annotationView
        }
            
            
            // Handle Trolleys
        else if let trolleyAnnotation = annotation as? Trolley {
            
            var annotationView: TrolleyAnnotationView! = mapView.dequeueReusableAnnotationViewWithIdentifier(trolleyAnnotationReuseIdentifier) as? TrolleyAnnotationView
            if annotationView == nil {
                annotationView = TrolleyAnnotationView(annotation: trolleyAnnotation, reuseIdentifier: trolleyAnnotationReuseIdentifier)
                annotationView.frame = CGRectMake(0, 0, 50, 50)
            }
            
            annotationView.tintColor = UIColor.trolleyColorForID(trolleyAnnotation.ID)
            annotationView.trolleyNumber = trolleyAnnotation.ID
            annotationView.annotation = trolleyAnnotation
            
            returnView = annotationView
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.updateAnnotationZIndexesInMapView(mapView)
        }
        
        return returnView
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.lineWidth = 6.0
        
        if let routeOverlay = overlay as? TrolleyRouteOverlay {
            renderer.strokeColor = UIColor.routeColorForIndex(routeOverlay.colorIndex)
        }
        
        return renderer
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        annotationSelectionAction?(annotationView: view)
        updateAnnotationZIndexesInMapView(mapView)
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        annotationDeselectionAction?(annotationView: view)
        updateAnnotationZIndexesInMapView(mapView)
    }
    
    //    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    //        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
    //        mapView.setRegion(region, animated: true)
    //    }
    
    private func updateAnnotationZIndexesInMapView(mapView: MKMapView) {
        
        for annotation in mapView.annotations {
            if let trolley = annotation as? Trolley,
                view = mapView.viewForAnnotation(trolley) {
                    view.superview?.bringSubviewToFront(view)
            }
        }
        
        if let view = mapView.viewForAnnotation(mapView.userLocation) {
            view.superview?.bringSubviewToFront(view)
        }
    }
}
