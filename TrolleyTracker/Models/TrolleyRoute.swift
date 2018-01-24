//
//  TrolleyRoute.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/19/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit


/// Represents a route that trolleys follow. 
struct TrolleyRoute: Equatable {

    static func ==(lhs: TrolleyRoute, rhs: TrolleyRoute) -> Bool {
        return lhs.ID == rhs.ID
    }

    let ID: Int
    let shortName: String
    let longName: String
    let routeDescription: String
    let flagStopsOnly: Bool
    let color: UIColor
    let stops: [TrolleyStop]

    private let _shapeCoordinates: [Coordinate]
    var shapePoints: [CLLocation] {
        return _shapeCoordinates.map { $0.location }
    }
    
    lazy var overlay: MKOverlay = {
        
        let coordinates = self.shapePoints.map { $0.coordinate }
        let coordinatesPointer = UnsafeMutablePointer<CLLocationCoordinate2D>(mutating: coordinates)
        let polyline = TrolleyRouteOverlay(coordinates: coordinatesPointer, count: coordinates.count)
        polyline.color = color

        return polyline
    }()

    init(id: Int,
         shortName: String,
         longName: String,
         routeDescription: String,
         flagStopsOnly: Bool,
         stops: [TrolleyStop],
         shapeCoordinates: [Coordinate],
         color: UIColor) {
        self.ID = id
        self.shortName = shortName
        self.longName = longName
        self.routeDescription = routeDescription
        self.flagStopsOnly = flagStopsOnly
        self.stops = stops
        self._shapeCoordinates = shapeCoordinates
        self.color = color
    }    
}

struct _APIRoute: Codable {
    let ID: Int
    let ShortName: String
    let LongName: String
    let Description: String
    let FlagStopsOnly: Bool
    let RouteColorRGB: String
}

struct _APITrolleyRoute: Codable {
    let ID: Int
    let ShortName: String
    let LongName: String
    let Description: String
    let FlagStopsOnly: Bool

    let RouteShape: [_APIShapePoint]
    let Stops: [_APITrolleyStop]

    func route(withMetadata metadata: RouteMetadata?) -> TrolleyRoute {

        let color = metadata.map { UIColor(hex: $0.colorString) } ?? GreenlinkColor(routeName: ShortName)?.color ?? .black

        let stops = Stops.map {
            $0.trolleyStop(with: color)
        }
        let coords = RouteShape.map {
            $0.coordinate
        }
        return TrolleyRoute(id: ID,
                            shortName: ShortName,
                            longName: LongName,
                            routeDescription: Description,
                            flagStopsOnly: FlagStopsOnly,
                            stops: stops,
                            shapeCoordinates: coords,
                            color: color)
    }
}

struct _APITrolleyStop: Codable {
    let ID: Int
    let Name: String
    let Description: String
    let Lat: Double
    let Lon: Double
    let StopImageURL: String?
    let NextTrolleyArrivalTime: [Int: String]

    func trolleyStop(with color: UIColor) -> TrolleyStop {
        return TrolleyStop(name: Name,
                           latitude: Lat,
                           longitude: Lon,
                           description: Description,
                           ID: ID,
                           lastTrolleyArrivals: NextTrolleyArrivalTime,
                           color: color)
    }
}

struct _APIShapePoint: Codable {
    let Lat: Double
    let Lon: Double

    var coordinate: Coordinate {
        return Coordinate(latitude: Lat, longitude: Lon)
    }
}
