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
    
    class var RunningTrolleys: DataRequest {
        return Alamofire.request(BaseURL + APIVersion + "/Trolleys/Running", method: .get).ttLog.ttValidate
    }
    
    class var AllTrolleys: DataRequest {
        return Alamofire.request(BaseURL + APIVersion + "/Trolleys", method: .get).ttLog.ttValidate
    }
    
    class var Stops: DataRequest {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Stops", method: .get).ttLog.ttValidate
    }
    
    class var Routes: DataRequest {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes", method: .get).ttLog.ttValidate
    }
    
    class func RouteDetail(_ routeID: String) -> DataRequest {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes/" + routeID, method: .get).ttLog.ttValidate
    }
    
    class func RoutesActive() -> DataRequest {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/Routes/Active", method: .get).ttLog.ttValidate
    }
    
    class func RouteSchedules() -> DataRequest {
        return Alamofire.request(self.BaseURL + self.APIVersion + "/RouteSchedules", method: .get).ttLog.ttValidate
    }
}

private extension DataRequest {
    
    var ttValidate: DataRequest {
        return self.validate(statusCode: 200..<300)
    }
    
    var ttLog: DataRequest {
        return self.responseString(encoding: String.Encoding.utf8, completionHandler: { (response) -> Void in
//            println("Request: \(request), Response: \(response), ResponseString: \(string), Error: \(error)")
        })
    }
}
