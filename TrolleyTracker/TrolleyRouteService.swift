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
    
    private var memoryCachedActiveRoutes: [TrolleyRoute]?
    private var memoryCachedRoutes = [Int : TrolleyRoute]()
    
    func loadTrolleyRoutes(completion: LoadTrolleyRouteCompletion) {

        if let cachedRoutes = memoryCachedActiveRoutes {
            completion(routes: cachedRoutes)
            return
        }
        
        let request = TrolleyRequests.RoutesActive()
        request.responseJSON { (response) -> Void in
            guard let json = response.result.value else { return }
            self.loadRouteDetailForRoutes(JSON(json), completion: completion)
        }
    }
    
    func loadTrolleyRoute(routeID: Int, completion: LoadTrolleyRouteCompletion) {
        if let route = memoryCachedRoutes[routeID] { completion(routes: [route]); return }
        loadRouteDetail(routeID, completion: completion)
    }
    
    private final func loadRouteDetailForRoutes(routes: JSON, completion: LoadTrolleyRouteCompletion) {
        
        var routeObjects = [TrolleyRoute]()
        
        for (index, route) in routes.arrayValue.enumerate() {
            if let routeID = route["ID"].int {

                dispatch_group_enter(group)
                
                loadRouteDetail(routeID, colorIndex: index, completion: { (routes) in
                    routeObjects += routes
                    dispatch_group_leave(self.group)
                })
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.memoryCachedActiveRoutes = routeObjects
            completion(routes: routeObjects)
        }
    }
    
    private final func loadRouteDetail(routeID: Int, colorIndex: Int = 0, completion: LoadTrolleyRouteCompletion) {
        
        TrolleyRequests.RouteDetail("\(routeID)").responseJSON { (response) -> Void in
            
            var routeObjects = [TrolleyRoute]()
            
            defer {
                dispatch_async(dispatch_get_main_queue()) {
                    for route in routeObjects {
                        self.memoryCachedRoutes[route.ID] = route
                    }
                    completion(routes: routeObjects)
                }
            }
            
            guard let json = response.result.value else { return }
            if let route = TrolleyRoute(json: JSON(json), colorIndex: colorIndex) {
                routeObjects.append(route)
            }
        }
    }
}