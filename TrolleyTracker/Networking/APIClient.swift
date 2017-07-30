//
//  APIClient.swift
//  TrolleyTracker
//
//  Created by Austin on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class APIClient {

    typealias JSONResponse = (Result<Data>) -> Void

    func fetchAllTrolleys(completion: JSONResponse) {

    }

    func fetchRunningTrolleys(completion: JSONResponse) {

    }

    func fetchRouteDetail(for route: String, completion: JSONResponse) {

    }

    func fetchAllRoutes(completion: JSONResponse) {

    }

    func fetchActiveRoutes(completion: JSONResponse) {

    }

    func fetchRouteSchedules(completion: JSONResponse) {
        
    }
}

private class NetworkOperation {
    
}
