//
//  Alamofire+TrolleyRequests.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/15/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import Alamofire


class TrolleyRequests {
    
    private class var BaseURL: String {
        get {
            switch EnvironmentVariables.currentBuildConfiguration() {
            case .Test:
                return "http://yeahthattrolley.azurewebsites.net/api"
            default:
                return "http://tracker.wallinginfosystems.com/api"
            }
        }
    }
    
    private class var APIVersion: String {
        get { return "/v1" }
    }
    
    class var RunningTrolleys: Request {
        get { return Alamofire.request(.GET, BaseURL + APIVersion + "/Trolleys/Running", parameters: nil).ttLog.ttValidate }
    }
    
    class var AllTrolleys: Request {
        get { return Alamofire.request(.GET, BaseURL + APIVersion + "/Trolleys", parameters: nil).ttLog.ttValidate }
    }
    
    class var Stops: Request {
        get { return Alamofire.request(.GET, self.BaseURL + self.APIVersion + "/Stops", parameters: nil).ttLog.ttValidate }
    }
    
    class var Routes: Request {
        get { return Alamofire.request(.GET, self.BaseURL + self.APIVersion + "/Routes", parameters: nil).ttLog.ttValidate }
    }
    
    class func RouteDetail(routeID: String) -> Request {
        return Alamofire.request(.GET, self.BaseURL + self.APIVersion + "/Routes/" + routeID, parameters: nil).ttLog.ttValidate
    }
    
    class func RoutesActive() -> Request {
        return Alamofire.request(.GET, self.BaseURL + self.APIVersion + "/Routes/Active", parameters: nil).ttLog.ttValidate
    }
    
    class func RouteSchedules() -> Request {
        return Alamofire.request(.GET, self.BaseURL + self.APIVersion + "/RouteSchedules").ttLog.ttValidate
    }
}

private extension Request {
    
    private var ttValidate: Request {
        get { return self.validate(statusCode: 200..<300) }
    }
    
    private var ttLog: Request {
        get { return self.responseString(encoding: NSUTF8StringEncoding, completionHandler: { (response) -> Void in
//            println("Request: \(request), Response: \(response), ResponseString: \(string), Error: \(error)")
        }) }
    }
}