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

        for routeID in routeIDs {

            group.enter()

            loadRouteDetail(routeID, completion: { (routes) in
                self.fetchedRoutes += routes
                self.group.leave()
            })
        }

        group.notify(queue: DispatchQueue.main) {
            self.finish()
        }
    }

    private func loadRouteDetail(_ routeID: Int,
                                 completion: @escaping LoadTrolleyRouteCompletion) {

        client.fetchRouteDetail(for: "\(routeID)") { result in
            switch result {
            case .failure:
                completion([]); return
            case .success(let data):
                let decoder = JSONDecoder()
                guard let rawRoute = try? decoder.decode(_APITrolleyRoute.self, from: data) else {
                    completion([])
                    return
                }
                let route = rawRoute.route()
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

            switch result {
            case .failure:
                return
            case .success(let data):

                let jsonDecoder = JSONDecoder()
                guard let rawRoutes = try? jsonDecoder.decode([_APIRoute].self, from: data) else {
                    self.finish()
                    return
                }
                self.fetchedRouteIDs = rawRoutes.map { $0.ID }
            }

            self.finish()
        }
    }
}
