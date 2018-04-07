//
//  TrolleyStopService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

private struct CacheItem<T> {
    let timestamp: Date
    let payload: T

    func isNewerThan(_ minutes: Int) -> Bool {
        let allowedSeconds = TimeInterval(minutes * 60)
        return timestamp.timeIntervalSinceNow > -allowedSeconds
    }
}

class TrolleyRouteServiceLive: TrolleyRouteService {

    private let client: APIClient
    private let queue: OperationQueue = OperationQueue()
    private let metadataStore: RouteMetadataStore
    
    private var memoryCachedActiveRoutes: CacheItem<[TrolleyRoute]>?
    private var memoryCachedRoutes = [Int : TrolleyRoute]()

    var currentActiveRoutes: [TrolleyRoute] {
        return memoryCachedActiveRoutes?.payload ?? []
    }

    init(client: APIClient) {
        self.client = client
        self.metadataStore = RouteMetadataStore()
    }

    func loadTrolleyRoutes(_ completion: @escaping LoadTrolleyRouteCompletion) {

        if let cachedRoutes = memoryCachedActiveRoutes,
            cachedRoutes.isNewerThan(15),
            !cachedRoutes.timestamp.isAcrossQuarterHourBoundryFromNow {
            DispatchQueue.main.async {
                completion(cachedRoutes.payload)
            }
            return
        }

        let op = FetchActiveRouteIDsOperation(client: client, metadataStore: metadataStore)
        op.completionBlock = { [weak op] in
            guard let ids = op?.fetchedRouteIDs else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            self.fetchActiveRouteIDsFromNetwork(ids, completion: completion)
        }
        queue.addOperation(op)
    }
    
    func loadTrolleyRoute(_ routeID: Int, completion: @escaping LoadTrolleyRouteCompletion) {
        if let route = memoryCachedRoutes[routeID] { completion([route]); return }

        let op = FetchRouteDetailOperation(routeIDs: [routeID], client: client, metadataStore: metadataStore)
        op.completionBlock = { [weak op] in

            guard let fetchedRoute = op?.fetchedRoutes.first else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            self.memoryCachedRoutes[routeID] = fetchedRoute
            DispatchQueue.main.async {
                completion([fetchedRoute])
            }
        }
        queue.addOperation(op)
    }

    private func fetchActiveRouteIDsFromNetwork(_ routeIDs: [Int],
                                                completion: @escaping LoadTrolleyRouteCompletion) {

        let op = FetchRouteDetailOperation(routeIDs: routeIDs, client: client, metadataStore: metadataStore)
        op.completionBlock = { [weak op] in

            guard let fetchedRoutes = op?.fetchedRoutes else {
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }

            self.memoryCachedActiveRoutes = CacheItem(timestamp: Date(), payload: fetchedRoutes)
            DispatchQueue.main.async {
                completion(fetchedRoutes)
            }
        }
        queue.addOperation(op)
    }
}

class RouteMetadataStore {

    private var metadata: [Int: RouteMetadata] = [:]

    func store(route: _APIRoute) {
        metadata[route.ID] = RouteMetadata(route: route)
    }

    func metadata(forRoute route: _APITrolleyRoute) -> RouteMetadata? {
        return metadata[route.ID]
    }
}

struct RouteMetadata {
    let colorString: String

    init(route: _APIRoute) {
        self.colorString = route.RouteColorRGB
    }
}
