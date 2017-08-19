//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import CoreLocation

class TrolleyLocationServiceLive: TrolleyLocationService {
    
    var trolleyObservers = ObserverSet<[Trolley]>()

    private var updateTimer: Timer?
    
    private var allTrolleys: [Trolley] = []

    private let client: APIClient

    init(client: APIClient) {
        self.client = client
    }
    
    func startTrackingTrolleys() {
        
        let startUpdating = {
            
            // -- Get an initial update on the trolleys
            self.getRunningTrolleys()
            
            // -- Start a timer for updating currently running trolleys (trolleys/running)
            self.updateTimer = Timer.scheduledTimer(timeInterval: 10,
                                                    target: self,
                                                    selector: #selector(self.getRunningTrolleys),
                                                    userInfo: nil,
                                                    repeats: true)
        }
        
        // If we have already retrieved the Trolley list, just start updating them.
        guard allTrolleys.isEmpty else {
            startUpdating()
            return
        }
        
        // Otherwise, retrieve list of all trolleys first

        client.fetchAllTrolleys { result in
            switch result {
            case .failure:
                break
            case .success(let data):
                self.allTrolleys = self.parseTrolleysFromJSON(data)
                startUpdating()
            }
        }
    }
    
    func stopTrackingTrolley() {
        updateTimer?.invalidate()
    }
    
    @objc private func getRunningTrolleys() {

        client.fetchRunningTrolleys { result in
            switch result {
            case .failure:
                break
            case .success(let data):

                let trolleys = self.parseRunningTrolleysFromJSON(data)

                for trolley in trolleys {
                    self.updateTrolleysWithTrolley(trolley)
                }

                let activateUpdatedTrolleys = self.allTrolleys.matching(trolleys)

                DispatchQueue.main.async {
                    self.trolleyObservers.notify(activateUpdatedTrolleys)
                }
            }
        }
    }

    private func updateTrolleysWithTrolley(_ runningTrolley: _APIRunningTrolley) {
       
        var trolleys = self.allTrolleys
        
        // Find the matching trolley in the allTrolleys array
        guard let index = trolleys.index(where: { trolley in
            trolley.ID == runningTrolley.ID
        }) else {
            return
        }

        // Create a new trolley with an updated location
        let location = CLLocation(latitude: runningTrolley.Lat,
                                  longitude: runningTrolley.Lon)
        let updatedTrolley = Trolley(trolley: trolleys[index], location: location)

        // Store that back in the array
        trolleys.remove(at: index)
        trolleys.append(updatedTrolley)
        allTrolleys = trolleys
    }

    private func parseTrolleysFromJSON(_ json: Data) -> [Trolley] {
        let decoder = JSONDecoder()
        guard let raw = try? decoder.decode([_APITrolley].self, from: json) else {
            return []
        }
        return raw.map { $0.trolley }
    }

    private func parseRunningTrolleysFromJSON(_ json: Data) -> [_APIRunningTrolley] {
        let decoder = JSONDecoder()
        guard let raw = try? decoder.decode([_APIRunningTrolley].self, from: json) else {
            return []
        }
        return raw
    }
}

extension Array where Element == Trolley {

    func matching(_ runningTrolleys: [_APIRunningTrolley]) -> [Trolley] {
        let runningIDs = runningTrolleys.map { $0.ID }
        return filter { runningIDs.contains($0.ID) }
    }
}
