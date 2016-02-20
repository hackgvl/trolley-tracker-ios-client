//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class TrolleyRouteServiceLive: TrolleyRouteService {
    
    let group = dispatch_group_create()
    
 
    static var sharedService = TrolleyRouteServiceLive()
    
    private var memoryCachedRoutes: [TrolleyRoute]?
    
    func loadTrolleyRoutes(completion: LoadTrolleyRouteCompletion) {

        if let cachedRoutes = memoryCachedRoutes {
            completion(routes: cachedRoutes)
            return 
        }
        
        let request = TrolleyRequests.RoutesActive()
        request.responseJSON { (response) -> Void in
            guard let json = response.result.value else { return }
            self.loadRouteDetailForRoutes(JSON(json), completion: completion)
        }
    }
    
    private func loadRouteDetailForRoutes(routes: JSON, completion: LoadTrolleyRouteCompletion) {
        
        var routeObjects = [TrolleyRoute]()
        
        for (index, route) in routes.arrayValue.enumerate() {
            if let routeID = route["ID"].int {

                dispatch_group_enter(group)
                
                TrolleyRequests.RouteDetail("\(routeID)").responseJSON { (response) -> Void in
                    guard let json = response.result.value else { return }
                    if let route = TrolleyRoute(json: JSON(json), colorIndex: index) {
                        routeObjects.append(route)
                    }
                    
                    dispatch_group_leave(self.group)
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.memoryCachedRoutes = routeObjects
            completion(routes: routeObjects)
        }
    }
}