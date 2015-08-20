//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TrolleyRouteService {
    
    let group = dispatch_group_create()
    
    typealias LoadTrolleyRouteCompletion = (routes: [TrolleyRoute]) -> Void
 
    static var sharedService = TrolleyRouteService()
    
    func loadTrolleyRoutes(completion: LoadTrolleyRouteCompletion) {
        
        // Call "/Stops" to get the list of stops
        TrolleyRequests.Routes.responseJSON { (request, response, json, error) -> Void in
            
            if let json: AnyObject = json {
                self.loadRouteDetailForRoutes(JSON(json), completion: completion)
            }
        }
    }
    
    private func loadRouteDetailForRoutes(routes: JSON, completion: LoadTrolleyRouteCompletion) {
        
        var routeObjects = [TrolleyRoute]()
        
        for route in routes.arrayValue {
            if let routeID = route["ID"].int {

                dispatch_group_enter(group)
                
                TrolleyRequests.RouteDetail("\(routeID)").responseJSON { (request, response, json, error) -> Void in

                    if let json: AnyObject = json,
                    route = TrolleyRoute(json: JSON(json)) {
                        routeObjects.append(route)
                    }
                    
                    dispatch_group_leave(self.group)
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            completion(routes: routeObjects)
        }
    }
    
    private func parseRoutesFromJSON(json: AnyObject?) -> [TrolleyRoute] {
        
        var routes = [TrolleyRoute]()
        
        if let json: AnyObject = json
        {
            routes = JSON(json).arrayValue.map { TrolleyRoute(json: $0) }.filter { $0 != nil }.map { $0! }
        }
        
        return routes
    }
}