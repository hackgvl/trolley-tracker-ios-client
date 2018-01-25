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
    private let client: APIClient

    internal private(set) var fetchedRoutes: [TrolleyRoute] = []

    init(routeIDs: [Int], client: APIClient) {
        self.routeIDs = routeIDs
        self.client = client
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

    private func loadRouteDetail(_ routeID: Int,
                                 colorIndex: Int = 0,
                                 completion: @escaping LoadTrolleyRouteCompletion) {

        client.fetchRouteDetail(for: "\(routeID)") { result in
            switch result {
            case .failure:
                completion([]); return
            case .success(let data):
                let json = JSON(data)
                guard let route = TrolleyRoute(json: json, colorIndex: colorIndex) else {
                    completion([]); return
                }
                completion([route])
            }
        }
    }
}

class FetchActiveRouteIDsOperation: ConcurrentOperation {

    internal private(set) var fetchedRouteIDs: [Int] = []

    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }

    override func execute() {

        client.fetchActiveRoutes { result in

            defer {
                self.finish()
            }

            switch result {
            case .failure:
                return
            case .success(let data):
                let jsonArray =  JSON(data).arrayValue
                self.fetchedRouteIDs = jsonArray.flatMap { $0["ID"].int }
            }
        }
    }
}
