//
//  Schedule.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 10/12/15.
//  Copyright © 2015 Code For Greenville. All rights reserved.
//

import Foundation


//==================================================================
// MARK: - RouteTime
//==================================================================
struct RouteTime: Codable {
    let day: String
    let time: String

    init(day: String, time: String) {
        self.day = day
        self.time = time
    }

    init(rawSchedule: _APIRouteSchedule) {
        self.day = rawSchedule.DayOfWeek
        self.time = rawSchedule.StartTime + " - " + rawSchedule.EndTime
    }
}

//==================================================================
// MARK: - RouteSchedule
//==================================================================
struct RouteSchedule: Codable {
    let name: String
    let ID: Int
    let times: [RouteTime]
}


//==================================================================
// MARK: - APIRouteSchedule
//==================================================================
struct _APIRouteSchedule: Codable {
    let ID: Int
    let RouteID: Int
    let DayOfWeek: String
    let StartTime: String
    let EndTime: String
    let RouteLongName: String
}
