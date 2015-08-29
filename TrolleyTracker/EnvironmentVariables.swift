//
//  EnvironmentVariables.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 8/29/15.
//  Copyright (c) 2015 Code For Greenville. All rights reserved.
//

import Foundation


enum BuildConfiguration: String {
    case Release = "Release"
    case Test = "Test"
}

class EnvironmentVariables {
    
    class func currentConfigurationIsDebug() -> Bool {
        #if DEBUGGING
        return true
        #else
        return false
        #endif
    }
    
    class func currentBuildConfiguration() -> BuildConfiguration {
        
        var config: BuildConfiguration!
        
        #if TEST
        config = .Test
        #else
        config = .Release
        #endif
        
        println("Current configuration: \(config.rawValue)")
        
        return config
    }
}