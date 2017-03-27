//
//  RouteFetchOperations.swift
//  TrolleyTracker
//
//  Created by Austin on 3/26/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation


class FetchRouteDetailOperation: ConcurrentOperation {

    private let group = DispatchGroup()
    private let routeIDs: [Int]

    internal private(set) var fetchedRoutes: [TrolleyRoute] = []

    init(routeIDs: [Int]) {
        self.routeIDs = routeIDs
    }

    override func execute() {

        for (index, routeID) in routeIDs.enumerated() {

            group.enter()

            loadRouteDetail(routeID, colorIndex: index, completion: { (routes) in
                self.fetchedRoutes += routes
                self.group.leave()
            })
        }

        group.notify(queue: DispatchQueue.main) {
            self.finish()
        }
    }

    private func loadRouteDetail(_ routeID: Int, colorIndex: Int = 0, completion: @escaping LoadTrolleyRouteCompletion) {

        TrolleyRequests.RouteDetail("\(routeID)").responseJSON { (response) -> Void in

            guard let json = response.result.value,
                let route = TrolleyRoute(json: JSON(json), colorIndex: colorIndex) else {
                    completion([])
                    return
            }

            completion([route])
        }
    }
}

class FetchActiveRouteIDsOperation: ConcurrentOperation {

    internal private(set) var fetchedRouteIDs: [Int] = []

    override func execute() {

        let request = TrolleyRequests.RoutesActive()
        request.responseJSON { (response) -> Void in

            defer {
                self.finish()
            }

            guard let json = response.result.value else {
                return
            }

            let jsonArray = JSON(json).arrayValue
            self.fetchedRouteIDs = jsonArray.flatMap { $0["ID"].int }
        }
    }
}
