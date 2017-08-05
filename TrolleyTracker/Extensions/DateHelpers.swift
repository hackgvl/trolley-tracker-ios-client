//
//  DateHelpers.swift
//  TrolleyTracker
//
//  Created by Austin on 8/5/17.
//  Copyright © 2017 Code For Greenville. All rights reserved.
//

import Foundation

extension Date {

    var hasCrossedQuarterHourBoundry: Bool {

        let calendar = Calendar.current
        let cacheComps = calendar.component(.minute, from: self)
        let nowComps = Calendar.current.component(.minute, from: Date())

        guard cacheComps != nowComps else {
            return false
        }

        // If self minutes are greater than `now` minutes,
        // the range spans the top of the hour
        guard nowComps > cacheComps else {
            return true
        }

        let range = cacheComps..<nowComps
        let boundryMarkers = [0, 15, 30, 45, 60]

        for marker in boundryMarkers {
            if range.contains(marker) {
                return true
            }
        }

        return false
    }
}
