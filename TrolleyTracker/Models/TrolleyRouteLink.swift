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

            // Assign the route's color to the Trolley
            trolley.associatedRouteColor = assignedRoute.color
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

    var trolleys: [Trolley] {
        return flatMap { $0.trolleys }
    }
}

private extension Array where Element == TrolleyRoute {

    func route(for trolley: Trolley) -> Element? {
        let minimumScoreThreshhold: Float = 0.75
        let scores = self.scores(for: trolley)
        guard let highScore = scores.first else { return nil }
        guard highScore.0 > minimumScoreThreshhold else { return nil }
        return highScore.1
    }

    private func scores(for trolley: Trolley) -> [(Float, TrolleyRoute)] {

        let scores: [(Float, TrolleyRoute)] = self.map {
            ($0.score(for: trolley), $0)
        }

        let sorted = scores.sorted { (s1, s2) -> Bool in
            return s1.0 > s2.0
        }

        return sorted
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

private extension TrolleyRoute {

    func score(for trolley: Trolley) -> Float {
        let numberOfStops = Float(stops.count)
        let numberHitByTrolley = Float(stops.numberHitBy(trolley: trolley))

        guard numberHitByTrolley > 0 else { return 0 }

        let percentageHit = numberHitByTrolley / numberOfStops

        return percentageHit
    }
}

private extension Array where Element == TrolleyStop {

    func numberHitBy(trolley: Trolley) -> Int {
        var number = 0
        for stop in self {
            if stop.lastTrolleyArrivals.keys.contains(trolley.number ?? 0) {
                number += 1
            }
        }
        return number
    }
}
