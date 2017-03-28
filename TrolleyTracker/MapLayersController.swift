//
//  MapLayersController.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 3/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation
import MapKit
import os.log

class MapLayersController {

    let observers = ObserverSet<[MapLayerItemCollection]>()

    func fetchMapLayers() {

        let urlString = "https://data.openupstate.org/maps/parking-decks/geojson.php"
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if #available(iOS 10.0, *) {
                os_log("%@, %@, %@", String(describing: data), String(describing: response), String(describing: error))
            }
            guard let data = data else {
                return
            }

            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
                let json = JSON(jsonData)
                let features = json.geoJSONFeatures()
                let items: [MapLayerItem] = features.map {
                    let item: MapLayerItem = try! unbox(dictionary: $0)
                    return item
                }
                let collections = [
                    MapLayerItemCollection(name: "Parking Garages", items: items)
                    ]
                DispatchQueue.main.async {
                    self.observers.notify(collections)
                }
            }
            catch let error {
                print(error)
            }
        }
        task.resume()
    }
}

extension JSON {

    func geoJSONFeatures() -> [[String: Any]] {
        guard let featuresArray = self["features"].array else { return [[:]] }
        let dictionaries = featuresArray.flatMap({ $0.dictionaryObject })
        return dictionaries
    }
}
