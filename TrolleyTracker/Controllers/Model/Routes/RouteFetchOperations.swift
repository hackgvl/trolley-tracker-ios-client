//
//  RouteFetchOperations.swift
//  TrolleyTracker
//
//  Created by Austin on 3/26/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation
import os.log

class FetchRouteDetailOperation: ConcurrentOperation {

    private let group = DispatchGroup()
    private let routeIDs: [Int]
    private let client: APIClient
    private let metadataStore: RouteMetadataStore

    internal private(set) var fetchedRoutes: [TrolleyRoute] = []

    init(routeIDs: [Int],
         client: APIClient,
         metadataStore: RouteMetadataStore) {
        self.routeIDs = routeIDs
        self.client = client
        self.metadataStore = metadataStore
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
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let rawRoute = try decoder.decode(_APITrolleyRoute.self, from: data)
                    let metadata = self.metadataStore.metadata(forRoute: rawRoute)
                    let route = rawRoute.route(withMetadata: metadata)
                    completion([route])
                }
                catch let error {
                    os_log("Error decoding _APITrolleyRoute: %@", error as CVarArg)
                    completion([])
                    return
                }
            }
        }
    }
}

class FetchActiveRouteIDsOperation: ConcurrentOperation {

    internal private(set) var fetchedRouteIDs: [Int] = []

    private let client: APIClient
    private let metadataStore: RouteMetadataStore

    init(client: APIClient, metadataStore: RouteMetadataStore) {
        self.client = client
        self.metadataStore = metadataStore
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
                for route in rawRoutes {
                    self.metadataStore.store(route: route)
                }
            }

            self.finish()
        }
    }
}
