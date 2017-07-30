//
//  APIClient.swift
//  TrolleyTracker
//
//  Created by Austin on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

class APIClient {

    private let session: URLSession

    init(session: URLSession) {
        self.session = session

        session.configuration.httpAdditionalHeaders = [
            "Cache-Control":"no-cache",
            "Authorization":"Basic SU9TQ2xpZW50OklPU2lzdGhlYmVzdCEx",
            "Content-Type":"application/json",
        ]
    }

    typealias JSONResponse = (Result<Any>) -> Void

    func fetchAllTrolleys(completion: @escaping JSONResponse) {
        startDataTask(with: .allTrolleys, completion: completion)
    }

    func fetchRunningTrolleys(completion: @escaping JSONResponse) {
        startDataTask(with: .runningTrolleys, completion: completion)
    }

    func fetchRouteDetail(for route: String, completion: @escaping JSONResponse) {
        startDataTask(with: .routeDetail(for: route), completion: completion)
    }

    func fetchAllRoutes(completion: @escaping JSONResponse) {
        startDataTask(with: .routes, completion: completion)
    }

    func fetchActiveRoutes(completion: @escaping JSONResponse) {
        startDataTask(with: .routesActive, completion: completion)
    }

    func fetchRouteSchedules(completion: @escaping JSONResponse) {
        startDataTask(with: .routeSchedules, completion: completion)
    }

    private func startDataTask(with request: URLRequest,
                               completion: @escaping JSONResponse) {
        let task = session.dataTask(with: request) { (data, response, error) in
            let json = data.flatMap {
                try? JSONSerialization.jsonObject(with: $0, options: [])
            }
            let result = Result(value: json, error: error)
            completion(result)
        }
        task.resume()
    }
}
