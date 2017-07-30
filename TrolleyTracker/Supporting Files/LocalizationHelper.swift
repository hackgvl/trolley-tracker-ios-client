//
//  LocalizationHelper.swift
//  TrolleyTracker
//
//  Created by Austin Younts on 7/30/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

struct LS {

    private init() {}

    static var mapTitle: String {
        return string(for: "Map.Title")
    }
    static var scheduleTitle: String {
        return string(for: "Schedule.Title")
    }
    static var moreTitle: String {
        return string(for: "More.Title")
    }


    private static func string(for key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
