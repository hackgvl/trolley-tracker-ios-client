//
//  TrolleyRouteLink.swift
//  TrolleyTracker
//
//  Created by Austin on 8/19/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

/// Associates a TrolleyRoute with Trolleys assigned to that route.
struct TrolleyRouteLink {

    let trolleys: [Trolley]
    let route: TrolleyRoute

    static func link(trolleys: [Trolley], to routes: [TrolleyRoute]) -> [TrolleyRouteLink] {

        // Create links for each Route
        var map = routes.linkMap()

        // For each Trolley
        for trolley in trolleys {
            // Look for a route it should be assigned to
            guard let assignedRoute = routes.route(for: trolley) else {
                continue
            }

            // Add it to the route if found
            map[assignedRoute.ID]?.append(trolley)
        }

        let links: [TrolleyRouteLink] = map.map {
            guard let route = routes.route(with: $0.key) else { fatalError() }
            return TrolleyRouteLink(trolleys: $0.value, route: route)
        }

        return links
    }
}

extension Array where Element == TrolleyRouteLink {

    subscript(route: TrolleyRoute) -> TrolleyRouteLink? {
        get {
            guard let i = index(where: { link in
                link.route == route
            }) else { return nil }
            return self[i]
        }
    }

    subscript(trolley: Trolley) -> TrolleyRoute? {
        get {
            guard let i = index(where: { link in
                link.trolleys.contains(trolley)
            }) else { return nil }
            return self[i].route
        }
    }

    var trolleys: [Trolley] {
        return flatMap { $0.trolleys }
    }
}

private extension Array where Element == TrolleyRoute {

    func route(for trolley: Trolley) -> Element? {
        return filter { $0.color == trolley.tintColor }.first
    }

    func linkMap() -> [Int: [Trolley]] {
        let routeIDs = map { $0.ID }
        var dictionary = [Int: [Trolley]]()
        for id in routeIDs {
            dictionary[id] = []
        }
        return dictionary
    }

    func route(with id: Int) -> Element? {
        for route in self {
            if route.ID == id {
                return route
            }
        }
        return nil
    }
}
