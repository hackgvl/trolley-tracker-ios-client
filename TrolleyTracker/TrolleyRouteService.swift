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
    
    let group = DispatchGroup()
 
    static var sharedService = TrolleyRouteServiceLive()
    
    fileprivate var memoryCachedActiveRoutes: [TrolleyRoute]?
    fileprivate var memoryCachedRoutes = [Int : TrolleyRoute]()
    
    func loadTrolleyRoutes(_ completion: LoadTrolleyRouteCompletion) {

        if let cachedRoutes = memoryCachedActiveRoutes {
            completion(cachedRoutes)
            return
        }
        
        let request = TrolleyRequests.RoutesActive()
        request.responseJSON { (response) -> Void in
            guard let json = response.result.value else { return }
            self.loadRouteDetailForRoutes(JSON(json), completion: completion)
        }
    }
    
    func loadTrolleyRoute(_ routeID: Int, completion: LoadTrolleyRouteCompletion) {
        if let route = memoryCachedRoutes[routeID] { completion([route]); return }
        loadRouteDetail(routeID, completion: completion)
    }
    
    fileprivate final func loadRouteDetailForRoutes(_ routes: JSON, completion: LoadTrolleyRouteCompletion) {
        
        var routeObjects = [TrolleyRoute]()
        
        for (index, route) in routes.arrayValue.enumerated() {
            if let routeID = route["ID"].int {

                group.enter()
                
                loadRouteDetail(routeID, colorIndex: index, completion: { (routes) in
                    routeObjects += routes
                    self.group.leave()
                })
            }
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.memoryCachedActiveRoutes = routeObjects
            completion(routeObjects)
        }
    }
    
    fileprivate final func loadRouteDetail(_ routeID: Int, colorIndex: Int = 0, completion: LoadTrolleyRouteCompletion) {
        
        TrolleyRequests.RouteDetail("\(routeID)").responseJSON { (response) -> Void in
            
            var routeObjects = [TrolleyRoute]()
            
            defer {
                DispatchQueue.main.async {
                    for route in routeObjects {
                        self.memoryCachedRoutes[route.ID] = route
                    }
                    completion(routeObjects)
                }
            }
            
            guard let json = response.result.value else { return }
            if let route = TrolleyRoute(json: JSON(json), colorIndex: colorIndex) {
                routeObjects.append(route)
            }
        }
    }
}
