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
        // TODO: Implement TrolleyRouteLink.linksFrom(trolleys:routes:)
        return []
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
