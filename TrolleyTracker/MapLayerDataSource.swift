//
//  MapLayerDataSource.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 3/28/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class MapLayerDataSource {

    private var items: [MapLayerItemCollection] = []

    var sectionsCount: Int {
        return 1
    }

    func itemCount(in section: Int) -> Int {
        return items.count
    }

    func item(at indexPath: IndexPath) -> MapLayerItemCollection {
        return items[indexPath.row]
    }

    func setItems(_ items: [MapLayerItemCollection]) {
        self.items = items
    }
}

struct MapLayerItemCollection {
    let name: String
    let items: [MapLayerItem]
}

struct MapLayerItem {
    let name: String
    let extendedDescription: String
    let lat: Double
    let lon: Double
    let address: String

    func annotation() -> MapItemContainer {

        let location = CLLocation(latitude: lat, longitude: lon)
        let title = name
        let subtitle = "\(extendedDescription)\n\(address)"

        return MapItemContainer(coordinate: location.coordinate, title: title, subtitle: subtitle)
    }
}

extension MapLayerItem: Unboxable {

    init(unboxer: Unboxer) throws {
        self.name = try unboxer.unbox(keyPath: "properties.title")
        self.extendedDescription = try unboxer.unbox(keyPath: "properties.cost_of_parking")
        self.address = try unboxer.unbox(keyPath: "properties.address")

        let cArray: [Double] = try unboxer.unbox(keyPath: "geometry.coordinates")
        self.lat = cArray[1]
        self.lon = cArray[0]
    }
}

class MapItemContainer: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        willSet {
            willChangeValue(forKey: "coordinate")
        }
        didSet {
            didChangeValue(forKey: "coordinate")
        }
    }

    var title: String?
    var subtitle: String?

    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
