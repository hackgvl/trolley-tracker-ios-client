//
//  TrolleyLocationService.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 6/16/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation
import Alamofire

protocol TrolleyLocationServiceDelegate {
    
}

class TTTrolleyLocationService {
    
    static var sharedService = TTTrolleyLocationService()
    
//    func addDelegate(delegate: TrolleyLocationServiceDelegate) {
//        
//    }
//    
//    func getTrolleys() {
//        // Fetch Request
//        Alamofire.request(.GET, "http://104.131.44.166/api/v1/trolly/1/location", parameters: nil)
//            .validate(statusCode: 200..<300)
//            .responseJSON{(request, response, JSON, error) in
//                if (error == nil)
//                {
//                    println("HTTP Response Body: \(JSON)")
//                }
//                else
//                {
//                    println("HTTP HTTP Request failed: \(error)")
//                }
//        }
//    }
}