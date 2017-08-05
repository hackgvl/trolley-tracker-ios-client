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
                annotationView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
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
            
            annotationView.tintColor = trolleyAnnotation.tintColor
            annotationView.trolleyNumber = trolleyAnnotation.ID
            annotationView.annotation = trolleyAnnotation
            
            returnView = annotationView
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
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.deSelectIfNeeded(mapView, view: view)
        }
    }

    private func deSelectIfNeeded(_ mapView: MKMapView, view: MKAnnotationView) {
        guard mapView.selectedAnnotations.isEmpty else { return }
        annotationDeselectionAction?(view)
    }
    
    //    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
    //        let region = MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01))
    //        mapView.setRegion(region, animated: true)
    //    }    
}
