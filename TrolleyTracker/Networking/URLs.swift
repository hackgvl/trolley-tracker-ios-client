//
//  URLs.swift
//  TrolleyTracker
//
//  Created by Austin on 7/29/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

extension URLRequest {

    static var runningTrolleys: URLRequest {
        return URLRequest(url: .runningTrolleys).set(method: .get)
    }

    static var allTrolleys: URLRequest {
        return URLRequest(url: .allTrolleys).set(method: .get)
    }

    static var stops: URLRequest {
        return URLRequest(url: .stops).set(method: .get)
    }

    static var routes: URLRequest {
        return URLRequest(url: .routes).set(method: .get)
    }

    static func routeDetail(for id: String) -> URLRequest {
        return URLRequest(url: .routeDetail(for: id)).set(method: .get)
    }

    static var routesActive: URLRequest {
        return URLRequest(url: .routesActive).set(method: .get)
    }

    static var routeSchedules: URLRequest {
        return URLRequest(url: .routeSchedules).set(method: .get)
    }
}

private extension URLRequest {

    func set(method: HTTPMethod) -> URLRequest {
        var new = self
        new.httpMethod = method.rawValue
        return new
    }
}

private extension URL {

    static var runningTrolleys: URL {
        return trolleyURL(with: "/Trolleys/Running")
    }

    static var allTrolleys: URL {
        return trolleyURL(with: "/Trolleys")
    }

    static var stops: URL {
        return trolleyURL(with: "/Stops")
    }

    static var routes: URL {
        return trolleyURL(with: "/Routes")
    }

    static func routeDetail(for id: String) -> URL {
        return trolleyURL(with: "/Routes/" + id)
    }

    static var routesActive: URL {
        return trolleyURL(with: "/Routes/Active")
    }

    static var routeSchedules: URL {
        return trolleyURL(with: "/RouteSchedules")
    }

    // MARK: Helpers

    private static func trolleyURL(with path: String) -> URL {
        return URL(string: baseURL + apiVersion + path)!
    }

    private static var baseURL: String {
        switch EnvironmentVariables.currentBuildConfiguration() {
        case .Test:
            return "http://yeahthattrolley.azurewebsites.net/api"
        default:
            return "http://tracker.wallinginfosystems.com/api"
        }
    }

    private static var apiVersion: String {
        return "/v1"
    }
}

private enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}
