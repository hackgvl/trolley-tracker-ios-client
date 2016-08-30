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
    
    fileprivate class var BaseURL: String {
        get {
            switch EnvironmentVariables.currentBuildConfiguration() {
            case .Test:
                return "http://yeahthattrolley.azurewebsites.net/api"
            default:
                return "http://tracker.wallinginfosystems.com/api"
            }
        }
    }
    
    fileprivate class var APIVersion: String {
        get { return "/v1" }
    }
    
    class var RunningTrolleys: Request {
        return Alamofire.request(BaseURL + APIVersion + "/Trolleys/Running", withMethod: .get).ttLog.ttValidate
    }
    
    class var AllTrolleys: Request {
        return Alamofire.request(BaseURL + APIVersion + "/Trolleys", withMethod: .get).ttLog.ttValidate
    }
    
    class var Stops: Request {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Stops", withMethod: .get).ttLog.ttValidate
    }
    
    class var Routes: Request {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes", withMethod: .get).ttLog.ttValidate
    }
    
    class func RouteDetail(_ routeID: String) -> Request {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes/" + routeID, withMethod: .get).ttLog.ttValidate
    }
    
    class func RoutesActive() -> Request {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes/Active", withMethod: .get).ttLog.ttValidate
    }
    
    class func RouteSchedules() -> Request {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/RouteSchedules", withMethod: .get).ttLog.ttValidate
    }
}

private extension Request {
    
    var ttValidate: Request {
        return self.validate(statusCode: 200..<300)
    }
    
    var ttLog: Request {
        return self.responseString(encoding: String.Encoding.utf8, completionHandler: { (response) -> Void in
//            println("Request: \(request), Response: \(response), ResponseString: \(string), Error: \(error)")
        })
    }
}
